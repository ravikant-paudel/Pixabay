import 'package:pixabay/api_service.dart';
import 'package:pixabay/feature/models/image_model.dart';

class SearchService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> searchImages(String query) async {
    return await _apiService.searchImages(query);
  }
}
