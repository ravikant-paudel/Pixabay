import 'package:pixabay/feature/models/image_model.dart';
import 'package:pixabay/network/api_config.dart';
import 'package:pixabay/network/api_service.dart';

class SearchService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> searchImages(String query, {int page = 1}) async {
    final response = await _apiService.get(
      '',
      queryParameters: {'key': ApiConfig.apiKey, 'q': query, 'image_type': 'photo', 'per_page': 20, 'page': page},
    );
    return ApiResponse.fromJson(response.data);
  }
}
