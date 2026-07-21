import 'dart:io';

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
    File imageFile,
  ) {
    return repository.savePhoto(
      photo,
      imageFile,
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