import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay/feature/favourite/favourite_bloc.dart';
import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/feature/search/search_page.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Images')),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          final favorites = context.read<FavoriteBloc>().favorites;

          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet!'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final image = favorites[index];
              return ImageItem(
                image: image,
                isFavorite: true,
                onTap: () => _showRemoveDialog(context, image),
              );
            },
          );
        },
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, ImageModel image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Favorites?'),
        content: const Text('Are you sure you want to remove this image from favorites?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                context.read<FavoriteBloc>().add(RemoveFromFavorites(image));
                Navigator.pop(context);
              },
              child: const Text('Remove')),
        ],
      ),
    );
  }
}
