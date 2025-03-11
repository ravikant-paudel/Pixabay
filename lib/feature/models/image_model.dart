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
