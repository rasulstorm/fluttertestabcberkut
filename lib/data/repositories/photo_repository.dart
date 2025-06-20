import '../../core/models/photo.dart';
import '../../domain/entities/photo_entity.dart';
import '../../domain/repositories/photo_repository_interface.dart';
import '../sources/unsplash_api.dart';

class PhotoRepository implements IPhotoRepository {
  @override
  Future<List<PhotoEntity>> fetchRandomPhotos(int count) async {
    final photos = await UnsplashApi.fetchRandomPhotos(count);
    return photos.map((photo) => photo.toEntity()).toList();
  }

  @override
  Future<List<PhotoEntity>> searchPhotos(String query) async {
    final photos = await UnsplashApi.searchPhotos(query);
    return photos.map((photo) => photo.toEntity()).toList();
  }

  Future<List<Photo>> fetchRandomPhotosForUI(int count) async {
    final entities = await fetchRandomPhotos(count);
    return entities.map((e) => Photo.fromEntity(e)).toList();
  }

  Future<List<Photo>> searchPhotosForUI(String query) async {
    final entities = await searchPhotos(query);
    return entities.map((e) => Photo.fromEntity(e)).toList();
  }
}
