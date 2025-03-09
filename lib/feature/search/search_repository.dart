import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/feature/search/search_service.dart';

class SearchRepository {
  final SearchService _searchService = SearchService();

  Future<ApiResponse> searchImages(String query) async {
    try {
      return await _searchService.searchImages(query);
    } catch (e) {
      throw Exception('Failed to search images: $e');
    }
  }
}
