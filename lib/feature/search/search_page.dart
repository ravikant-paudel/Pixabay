import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay/feature/favourite/favorite_screen.dart';
import 'package:pixabay/feature/favourite/favourite_bloc.dart';
import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/feature/search/search_bloc.dart';
import 'package:pixabay/feature/search/search_repository.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(SearchRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Image'),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _SearchBar(),
            const Expanded(child: _SearchResults()),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search images...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              context.read<SearchBloc>().add(FetchSearchEvent(_controller.text));
            },
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const Center(child: Text('Start searching for image!'));
        } else if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          return _ImageGrid(images: state.images);
        } else if (state is SearchError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<ImageModel> images;

  const _ImageGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          final isFavorite = context.watch<FavoriteBloc>().favorites.contains(image);
          return ImageItem(
            image: image,
            isFavorite: isFavorite,
            onTap: () => context.read<FavoriteBloc>().add(AddToFavoriteEvent(image)),
          );
        });
  }
}

class ImageItem extends StatelessWidget {
  final ImageModel image;
  final bool isFavorite;
  final VoidCallback onTap;

  const ImageItem({
    super.key,
    required this.image,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.network(
                    image.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: ${image.ownerName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Size: ${_formatSize(image.imageSize)}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }
}
