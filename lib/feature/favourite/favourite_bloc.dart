import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay/feature/models/image_model.dart';

abstract class FavoriteEvent {}

class AddToFavorites extends FavoriteEvent {
  final ImageModel image;
  AddToFavorites(this.image);
}

class RemoveFromFavorites extends FavoriteEvent {
  final ImageModel image;
  RemoveFromFavorites(this.image);
}

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoritesUpdated extends FavoriteState {
  final List<ImageModel> favorites;
  FavoritesUpdated(this.favorites);
}

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final List<ImageModel> _favorites = [];

  FavoriteBloc() : super(FavoriteInitial()) {
    on<AddToFavorites>(_addToFavorites);
    on<RemoveFromFavorites>(_removeFromFavorites);
  }

  List<ImageModel> get favorites => List.unmodifiable(_favorites);

  void _addToFavorites(AddToFavorites event, Emitter<FavoriteState> emit) {
    if (!_favorites.contains(event.image)) {
      _favorites.add(event.image);
      emit(FavoritesUpdated(List.from(_favorites)));
    }
  }

  void _removeFromFavorites(RemoveFromFavorites event, Emitter<FavoriteState> emit) {
    _favorites.remove(event.image);
    emit(FavoritesUpdated(List.from(_favorites)));
  }
}
