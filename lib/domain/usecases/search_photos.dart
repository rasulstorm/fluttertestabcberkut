import '../entities/photo_entity.dart';
import '../repositories/photo_repository_interface.dart';

class SearchPhotosUseCase {
  final IPhotoRepository repository;

  SearchPhotosUseCase(this.repository);

  Future<List<PhotoEntity>> call(String query) {
    return repository.searchPhotos(query);
  }
}
