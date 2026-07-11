import '../models/relationship_photo.dart';

abstract class RelationshipPhotoRepository {
  Future<List<RelationshipPhoto>> getPhotos(
    String chapterId,
  );

  Future<void> savePhoto(
    RelationshipPhoto photo,
  );

  Future<void> deletePhoto(
    String photoId,
  );
}