import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay/feature/favourite/favorite_bloc.dart';
import 'package:pixabay/feature/models/image_model.dart';

void main() {
  late FavoriteBloc favoriteBloc;
  final testImage1 = ImageModel(
    id: 1,
    tags: 'nature',
    ownerName: 'Test Owner',
    imageUrl: 'http://example.com/image1.jpg',
    imageSize: 1024,
  );

  final testImage2 = ImageModel(
    id: 2,
    tags: 'ocean',
    ownerName: 'Test Owner 2',
    imageUrl: 'http://example.com/image2.jpg',
    imageSize: 2048,
  );

  setUp(() {
    favoriteBloc = FavoriteBloc();
  });

  tearDown(() {
    favoriteBloc.close();
  });

  group('FavoriteBloc tests', () {
    test('initial state is FavoriteInitial', () {
      expect(favoriteBloc.state, isA<FavoriteInitial>());
    });

    blocTest<FavoriteBloc, FavoriteState>(
      'emits [FavoritesUpdated] with one item when AddToFavoriteEvent is added',
      build: () => favoriteBloc,
      act: (bloc) => bloc.add(AddToFavoriteEvent(testImage1)),
      expect: () => [
        FavoritesUpdated([testImage1]),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'does not add duplicate items when same image is added again',
      build: () => favoriteBloc,
      act: (bloc) {
        bloc.add(AddToFavoriteEvent(testImage1));
        bloc.add(AddToFavoriteEvent(testImage1));
      },
      expect: () => [
        FavoritesUpdated([testImage1]),
      ],
    );

    blocTest<FavoriteBloc, FavoriteState>(
      'removes last item and emits empty list',
      build: () => favoriteBloc,
      seed: () => FavoritesUpdated([testImage1]),
      act: (bloc) => bloc.add(RemoveFromFavoriteEvent(testImage1)),
      expect: () => [
        FavoritesUpdated([]),
      ],
    );
  });
}
