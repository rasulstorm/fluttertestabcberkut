import '../../domain/entities/photo_entity.dart';

class Photo {
  final String id;
  final String description;
  final String thumbUrl;
  final String fullUrl;
  final String authorName;

  Photo({
    required this.id,
    required this.description,
    required this.thumbUrl,
    required this.fullUrl,
    required this.authorName,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      description: json['description'] ?? json['alt_description'] ?? '',
      thumbUrl: json['urls']['small'],
      fullUrl: json['urls']['regular'],
      authorName: json['user']['name'],
    );
  }

  PhotoEntity toEntity() {
    return PhotoEntity(
      id: id,
      description: description,
      thumbUrl: thumbUrl,
      fullUrl: fullUrl,
      authorName: authorName,
    );
  }

  factory Photo.fromEntity(PhotoEntity entity) {
    return Photo(
      id: entity.id,
      description: entity.description,
      thumbUrl: entity.thumbUrl,
      fullUrl: entity.fullUrl,
      authorName: entity.authorName,
    );
  }
}
