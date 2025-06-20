import '../entities/photo_entity.dart';
import '../repositories/photo_repository_interface.dart';

class FetchRandomPhotosUseCase {
  final IPhotoRepository repository;

  FetchRandomPhotosUseCase(this.repository);

  Future<List<PhotoEntity>> call(int count) {
    return repository.fetchRandomPhotos(count);
  }
}
