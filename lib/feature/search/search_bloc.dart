import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/feature/search/search_repository.dart';

abstract class SearchEvent {}

class FetchSearchEvent extends SearchEvent {
  final String query;

  FetchSearchEvent(this.query);
}

class LoadMoreSearchEvent extends SearchEvent {}

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  SearchLoaded({
    required this.images,
    this.hasMore = true,
    this.page = 1,
    this.isLoadingMore = false,
  });

  final List<ImageModel> images;
  final bool hasMore;
  final int page;
  final bool isLoadingMore;

  SearchLoaded copyWith({
    List<ImageModel>? images,
    bool? hasMore,
    int? page,
    bool? isLoadingMore,
  }) {
    return SearchLoaded(
      images: images ?? this.images,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class SearchError extends SearchState {
  SearchError(this.message);

  final String message;
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;
  String _searchQuery = '';

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<FetchSearchEvent>(_onFetch);
    on<LoadMoreSearchEvent>(_onLoadMore);
  }

  Future<void> _onFetch(
    FetchSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    _searchQuery = event.query;
    if (_searchQuery.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final response = await _repository.searchImages(event.query);
      emit(
        SearchLoaded(
          images: response.hits,
          hasMore: response.hits.length == 20,
          page: response.page,
        ),
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadMore(LoadMoreSearchEvent event, Emitter<SearchState> emit) async {
    final currentState = state;
    if (currentState is SearchLoaded && currentState.hasMore) {
      emit(currentState.copyWith(isLoadingMore: true));
      try {
        final nextPage = currentState.page + 1;
        final response = await _repository.searchImages(
          _searchQuery,
          page: nextPage,
        );

        emit(currentState.copyWith(
          images: [...currentState.images, ...response.hits],
          hasMore: response.hits.length == 20,
          page: nextPage,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
        emit(SearchError(e.toString()));
      }
    }
  }
}
