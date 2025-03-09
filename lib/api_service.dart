import 'package:dio/dio.dart';
import 'package:pixabay/feature/models/image_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<ApiResponse> searchImages(String query) async {
    try {
      final response = await _dio.get(
        'https://pixabay.com/api/',
        queryParameters: {
          'key': '49217748-9a3a1bd79793f83e4d038db8f',
          'q': query,
          'image_type': 'photo',
          'per_page': 20,
        },
      );
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load images');
    }
  }
}
