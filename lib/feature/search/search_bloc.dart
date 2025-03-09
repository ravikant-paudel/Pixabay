import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/feature/search/search_repository.dart';

abstract class SearchEvent {}

class FetchSearchEvent extends SearchEvent {
  final String query;

  FetchSearchEvent(this.query);
}

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ImageModel> images;

  SearchLoaded(this.images);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<FetchSearchEvent>(_onFetch);
  }

  Future<void> _onFetch(
    FetchSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final response = await _repository.searchImages(event.query);
      emit(SearchLoaded(response.hits));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
