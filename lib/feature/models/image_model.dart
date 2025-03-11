class ApiResponse {
  final int total;
  final int totalHits;
  final List<ImageModel> hits;
  final int page;

  ApiResponse({
    required this.total,
    required this.totalHits,
    required this.hits,
    this.page = 1,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, {int page = 1}) {
    return ApiResponse(
      total: json['total'],
      totalHits: json['totalHits'],
      hits: (json['hits'] as List).map((i) => ImageModel.fromJson(i)).toList(),
      page: page,
    );
  }
}

class ImageModel {
  final int id;
  final String tags;
  final String ownerName;
  final String imageUrl;
  final int imageSize;

  ImageModel({
    required this.id,
    required this.tags,
    required this.ownerName,
    required this.imageUrl,
    required this.imageSize,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      tags: json['tags'],
      ownerName: json['user'],
      imageUrl: json['webformatURL'],
      imageSize: json['imageSize'],
    );
  }
}
