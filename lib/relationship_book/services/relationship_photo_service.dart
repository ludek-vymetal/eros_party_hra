import '../models/relationship_photo.dart';
import '../repositories/relationship_photo_repository.dart';

class RelationshipPhotoService {
  final RelationshipPhotoRepository repository;

  const RelationshipPhotoService({
    required this.repository,
  });

  Future<List<RelationshipPhoto>> getPhotos(
    String chapterId,
  ) {
    return repository.getPhotos(
      chapterId,
    );
  }

  Future<void> savePhoto(
    RelationshipPhoto photo,
  ) {
    return repository.savePhoto(
      photo,
    );
  }

  Future<void> deletePhoto(
    String photoId,
  ) {
    return repository.deletePhoto(
      photoId,
    );
  }
}