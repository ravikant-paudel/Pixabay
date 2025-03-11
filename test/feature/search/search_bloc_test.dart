import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pixabay/feature/models/api_response_model.dart';
import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/feature/search/search_repository.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockSearchRepository;

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

  // Set up the mock repository
  setUp(() {
    mockSearchRepository = MockSearchRepository();
  });

  test('should return a list of images when searchImages is called', () async {
    when(() => mockSearchRepository.searchImages(testQuery)).thenAnswer(
      (_) async => ApiResponseModel(
        hits: testImages,
        totalHits: 2,
        total: 50000,
      ),
    );

    final response = await mockSearchRepository.searchImages(testQuery);

    // Assert: verify the model
    expect(response.hits.length, 2);
    expect(response.hits[0].tags, 'flower');
    expect(response.hits[1].tags, 'flower');
    expect(response.hits[0].ownerName, 'Ravikant 1');
    expect(response.hits[1].ownerName, 'Ravikant 2');
  });

  test('should throw an error when searchImages fails', () async {
    when(() => mockSearchRepository.searchImages(testQuery)).thenThrow(Exception('Failed to load images'));

    expect(() => mockSearchRepository.searchImages(testQuery), throwsException);
  });
}
