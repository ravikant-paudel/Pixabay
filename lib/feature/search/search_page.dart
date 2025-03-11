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

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search images...',
                border: const OutlineInputBorder(),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchBloc>().add(FetchSearchEvent(''));
                        },
                      ),
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          if (state.images.isEmpty) {
            return const Center(child: Text('Image not found'));
          } else {
            return _ImageGrid(
              images: state.images,
              hasMore: state.hasMore,
              isLoadingMore: state.isLoadingMore,
              onLoadMore: () => context.read<SearchBloc>().add(LoadMoreSearchEvent()),
            );
          }
        } else if (state is SearchError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(state.message)),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ImageGrid extends StatelessWidget {
  final List<ImageModel> images;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const _ImageGrid({
    required this.images,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels == notification.metrics.maxScrollExtent &&
            hasMore &&
            !isLoadingMore) {
          onLoadMore();
        }
        return false;
      },
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
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
              },
            ),
          ),
          if (isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(),
            )
        ],
      ),
    );
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
