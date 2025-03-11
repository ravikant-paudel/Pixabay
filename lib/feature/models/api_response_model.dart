import 'package:pixabay/feature/models/image_model.dart';

class ApiResponseModel {
  final int total;
  final int totalHits;
  final List<ImageModel> hits;
  final int page;

  ApiResponseModel({
    required this.total,
    required this.totalHits,
    required this.hits,
    this.page = 1,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json, {int page = 1}) {
    return ApiResponseModel(
      total: json['total'],
      totalHits: json['totalHits'],
      hits: (json['hits'] as List).map((i) => ImageModel.fromJson(i)).toList(),
      page: page,
    );
  }
}
