import 'package:pixabay/feature/models/api_response_model.dart';
import 'package:pixabay/network/api_config.dart';
import 'package:pixabay/network/api_service.dart';

class SearchService {
  final ApiService _apiService = ApiService();

  Future<ApiResponseModel> searchImages(String query, {int page = 1}) async {
    final response = await _apiService.get(
      '',
      queryParameters: {
        'key': ApiConfig.apiKey,
        'q': query,
        'image_type': 'photo',
        'per_page': 20,
        'page': page,
      },
    );
    return ApiResponseModel.fromJson(response.data);
  }
}
