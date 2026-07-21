import 'dart:io';

import '../models/relationship_photo.dart';

abstract class RelationshipPhotoRepository {
  Future<List<RelationshipPhoto>> getPhotos(
    String chapterId,
  );

  Future<void> savePhoto(
    RelationshipPhoto photo,
    File imageFile,
  );

  Future<void> deletePhoto(
    String photoId,
  );
}