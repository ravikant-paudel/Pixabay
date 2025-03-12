import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay/feature/models/image_model.dart';

abstract class FavoriteEvent {}

class AddToFavoriteEvent extends FavoriteEvent {
  final ImageModel image;
  AddToFavoriteEvent(this.image);
}

class RemoveFromFavoriteEvent extends FavoriteEvent {
  final ImageModel image;
  RemoveFromFavoriteEvent(this.image);
}

// Extend Equatable for proper state comparison
abstract class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoritesUpdated extends FavoriteState {
  final List<ImageModel> favorites;

  FavoritesUpdated(this.favorites);

  @override
  List<Object?> get props => [favorites]; // Ensures state comparison works
}

// BloC Implementation
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final List<ImageModel> _favorites = [];

  FavoriteBloc() : super(FavoriteInitial()) {
    on<AddToFavoriteEvent>(_addToFavorites);
    on<RemoveFromFavoriteEvent>(_removeFromFavorites);
  }

  List<ImageModel> get favorites => List.unmodifiable(_favorites);

  void _addToFavorites(AddToFavoriteEvent event, Emitter<FavoriteState> emit) {
    if (!_favorites.contains(event.image)) {
      _favorites.add(event.image);
      emit(FavoritesUpdated(List.from(_favorites)));
    }
  }

  void _removeFromFavorites(RemoveFromFavoriteEvent event, Emitter<FavoriteState> emit) {
    _favorites.remove(event.image);
    emit(FavoritesUpdated(List.from(_favorites)));
  }
}
