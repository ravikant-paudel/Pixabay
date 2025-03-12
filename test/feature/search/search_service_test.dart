import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixabay/feature/search/search_service.dart';
import 'package:pixabay/network/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late SearchService searchService;

  setUp(() {
    mockApiService = MockApiService();
    searchService = SearchService(apiService: mockApiService);
  });

  group('SearchService', () {
    test('searchImages returns ApiResponseModel when successful', () async {
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'total': 265302,
          'totalHits': 500,
          'hits': [
            {
              'id': 8342448,
              'tags': 'flower, flower background',
              'user': 'Ravikant Paudel',
              'webformatURL':
                  'https://pixabay.com/get/gbeb96df21ed2d8bd390698c81f1aedbf7162aa65e891e6342c370b354e58b53bd525826e1327b322fdd121041988808cf4f321ad8010258bd9a5b7c5052eef31_640.jpg',
              'imageSize': 2655455,
            }
          ]
        },
      );

      when(() => mockApiService.get(
            '',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => response);

      final result = await searchService.searchImages('flowers');

      expect(result.total, 265302);
      expect(result.totalHits, 500);
      expect(result.hits.length, 1);

      final image = result.hits[0];
      expect(image.id, 8342448);
      expect(image.tags, 'flower, flower background');
      expect(image.ownerName, 'Ravikant Paudel');
      expect(image.imageUrl,
          'https://pixabay.com/get/gbeb96df21ed2d8bd390698c81f1aedbf7162aa65e891e6342c370b354e58b53bd525826e1327b322fdd121041988808cf4f321ad8010258bd9a5b7c5052eef31_640.jpg');
      expect(image.imageSize, 2655455);
    });

    test('searchImages throws an exception when network error occurs', () async {
      when(() => mockApiService.get(
            '',
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network Error',
      ));

      expect(
        () async => await searchService.searchImages('flowers'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
