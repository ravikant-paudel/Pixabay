import 'package:pixabay/feature/models/api_response_model.dart';
import 'package:pixabay/feature/search/search_service.dart';

class SearchRepository {
  final SearchService _searchService = SearchService();

  Future<ApiResponseModel> searchImages(String query, {int page = 1}) async {
    try {
      return await _searchService.searchImages(
        query,
        page: page,
      );
    } catch (e) {
      throw Exception('Failed to search images: $e');
    }
  }
}
