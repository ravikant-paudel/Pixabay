import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixabay/feature/models/api_response_model.dart';
import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/feature/search/search_repository.dart';
import 'package:pixabay/feature/search/search_service.dart';

class MockSearchService extends Mock implements SearchService {}

void main() {
  late MockSearchService mockSearchService;
  late SearchRepository searchRepository;

  setUp(() {
    mockSearchService = MockSearchService();
    searchRepository = SearchRepository(searchService: mockSearchService);
  });

  group(
    'SearchRepository',
    () {
      test('searchImages returns ApiResponseModel when successful', () async {
        final mockResponse = ApiResponseModel(
          total: 26302,
          totalHits: 500,
          hits: [
            ImageModel(
              id: 834448,
              tags: 'flower, flower background',
              ownerName: 'Tien-seven',
              imageUrl: 'https://pixabay.com/get/gbeb96df21ed2d8bd.jpg',
              imageSize: 2655455,
            ),
          ],
        );

        when(() => mockSearchService.searchImages(
              any(),
              page: any(named: 'page'),
            )).thenAnswer((_) async => mockResponse);

        final result = await searchRepository.searchImages('flowers');

        expect(result.total, 26302);
        expect(result.totalHits, 500);
        expect(result.hits.length, 1);

        final image = result.hits[0];
        expect(image.id, 834448);
        expect(image.tags, 'flower, flower background');
        expect(image.ownerName, 'Tien-seven');
        expect(image.imageUrl, 'https://pixabay.com/get/gbeb96df21ed2d8bd.jpg');
        expect(image.imageSize, 2655455);
      });

      test(
        'searchImages throws an exception when SearchService fails',
        () async {
          when(() => mockSearchService.searchImages(any(), page: any(named: 'page'))).thenThrow(
            Exception('Failed to search images'),
          );

          expect(
            () async => await searchRepository.searchImages('flowers'),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Failed to search images'),
              ),
            ),
          );
        },
      );
    },
  );
}
