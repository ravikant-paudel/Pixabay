import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixabay/feature/models/api_response_model.dart';
import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/feature/search/search_bloc.dart';
import 'package:pixabay/feature/search/search_repository.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  group('SearchBloc tests', () {
    late MockSearchRepository mockRepository;
    late SearchBloc searchBloc;

    const testQuery = 'flowers';

    final testImages = [
      ImageModel(
        id: 1,
        tags: 'flower',
        ownerName: 'Ravikant 1',
        imageUrl: 'http://example.com/image1.jpg',
        imageSize: 1234,
      ),
      ImageModel(
        id: 2,
        tags: 'flower',
        ownerName: 'Ravikant 2',
        imageUrl: 'http://example.com/image2.jpg',
        imageSize: 5678,
      ),
    ];

    final testImagesFull = List.generate(
      20,
      (index) => ImageModel(
        id: index,
        tags: 'flower',
        ownerName: 'Owner $index',
        imageUrl: 'http://example.com/image$index.jpg',
        imageSize: 1000 + index,
      ),
    );

    final testNewImage = [
      ImageModel(
        id: 21,
        tags: 'flower',
        ownerName: 'Owner 21',
        imageUrl: 'http://example.com/image21.jpg',
        imageSize: 1021,
      ),
    ];

    setUp(() {
      mockRepository = MockSearchRepository();
      searchBloc = SearchBloc(mockRepository);
    });

    tearDown(() {
      searchBloc.close();
    });

    blocTest<SearchBloc, SearchState>(
      'emits [SearchInitial] when FetchSearchEvent is added with empty query',
      build: () => searchBloc,
      act: (bloc) => bloc.add(FetchSearchEvent('')),
      expect: () => [isA<SearchInitial>()],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchLoaded] when FetchSearchEvent succeeds with less than 20 images',
      build: () {
        when(() => mockRepository.searchImages(testQuery)).thenAnswer(
          (_) async => ApiResponseModel(
            hits: testImages,
            totalHits: 2,
            total: 50000,
          ),
        );
        return searchBloc;
      },
      act: (bloc) => bloc.add(FetchSearchEvent(testQuery)),
      expect: () => [
        isA<SearchLoading>(),
        predicate<SearchState>((state) {
          if (state is SearchLoaded) {
            return state.images.length == testImages.length && state.hasMore == false && state.page == 1 && state.isLoadingMore == false;
          }
          return false;
        }),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] when FetchSearchEvent fails',
      build: () {
        when(() => mockRepository.searchImages(testQuery)).thenThrow(Exception('error'));
        return searchBloc;
      },
      act: (bloc) => bloc.add(FetchSearchEvent(testQuery)),
      expect: () => [
        isA<SearchLoading>(),
        predicate<SearchState>((state) {
          return state is SearchError && state.message.contains('error');
        }),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits proper states when LoadMoreSearchEvent succeeds',
      build: () {
        when(() => mockRepository.searchImages(testQuery)).thenAnswer(
          (_) async => ApiResponseModel(
            hits: testImagesFull,
            totalHits: 20,
            total: 50000,
          ),
        );

        when(() => mockRepository.searchImages(testQuery, page: 2)).thenAnswer(
          (_) async => ApiResponseModel(
            hits: testNewImage,
            totalHits: 21,
            total: 50000,
          ),
        );
        return searchBloc;
      },
      act: (bloc) async {
        bloc.add(FetchSearchEvent(testQuery));

        await Future.delayed(Duration.zero);
        bloc.add(LoadMoreSearchEvent());
      },
      expect: () => [
        isA<SearchLoading>(),
        predicate<SearchState>((state) {
          return state is SearchLoaded &&
              state.images.length == testImagesFull.length &&
              state.hasMore == true &&
              state.page == 1 &&
              state.isLoadingMore == false;
        }),
        predicate<SearchState>((state) {
          return state is SearchLoaded && state.isLoadingMore == true;
        }),
        predicate<SearchState>((state) {
          return state is SearchLoaded &&
              state.images.length == testImagesFull.length + testNewImage.length &&
              state.page == 2 &&
              state.isLoadingMore == false &&
              state.hasMore == false;
        }),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits proper states when LoadMoreSearchEvent fails',
      build: () {
        when(() => mockRepository.searchImages(testQuery)).thenAnswer(
          (_) async => ApiResponseModel(
            hits: testImagesFull,
            totalHits: 20,
            total: 50000,
          ),
        );

        when(() => mockRepository.searchImages(testQuery, page: 2)).thenThrow(Exception('load more error'));
        return searchBloc;
      },
      act: (bloc) async {
        bloc.add(FetchSearchEvent(testQuery));
        await Future.delayed(Duration.zero);
        bloc.add(LoadMoreSearchEvent());
      },
      expect: () => [
        isA<SearchLoading>(),
        predicate<SearchState>((state) {
          return state is SearchLoaded &&
              state.images.length == testImagesFull.length &&
              state.hasMore == true &&
              state.page == 1 &&
              state.isLoadingMore == false;
        }),
        predicate<SearchState>((state) {
          return state is SearchLoaded && state.isLoadingMore == true;
        }),
        predicate<SearchState>((state) {
          return state is SearchLoaded && state.isLoadingMore == false;
        }),
        predicate<SearchState>((state) {
          return state is SearchError && state.message.contains('load more error');
        }),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchInitial] when ResetSearchEvent is added',
      build: () => searchBloc,
      act: (bloc) => bloc.add(ResetSearchEvent()),
      expect: () => [isA<SearchInitial>()],
    );
  });

  group('SearchLoaded.copyWith tests', () {
    final dummyImage = ImageModel(
      id: 1,
      tags: 'flower',
      ownerName: 'Test Owner',
      imageUrl: 'http://example.com/image.jpg',
      imageSize: 1000,
    );

    final original = SearchLoaded(
      images: [dummyImage],
      hasMore: true,
      page: 1,
      isLoadingMore: true,
    );

    test('copyWith without providing isLoadingMore returns same value', () {
      final copy = original.copyWith();
      expect(copy.isLoadingMore, equals(original.isLoadingMore));
    });

    test('copyWith with null isLoadingMore returns original value', () {
      final copy = original.copyWith(isLoadingMore: null);
      expect(copy.isLoadingMore, equals(original.isLoadingMore));
    });

    test('copyWith with explicit isLoadingMore returns new value', () {
      final copy = original.copyWith(isLoadingMore: false);
      expect(copy.isLoadingMore, equals(false));
    });
  });
}
