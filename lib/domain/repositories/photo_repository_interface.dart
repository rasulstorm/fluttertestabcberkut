import '../entities/photo_entity.dart';

abstract class IPhotoRepository {
  Future<List<PhotoEntity>> fetchRandomPhotos(int count);
  Future<List<PhotoEntity>> searchPhotos(String query);
}
