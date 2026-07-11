import '../relationship_photo_repository.dart';
import '../../models/relationship_photo.dart';

class LocalRelationshipPhotoRepository
    implements RelationshipPhotoRepository {

  static final List<RelationshipPhoto> _photos = [];

  @override
  Future<List<RelationshipPhoto>> getPhotos(
    String chapterId,
  ) async {
    return _photos
        .where(
          (photo) => photo.chapterId == chapterId,
        )
        .toList();
  }

  @override
  Future<void> savePhoto(
    RelationshipPhoto photo,
  ) async {
    _photos.removeWhere(
      (item) => item.id == photo.id,
    );

    _photos.add(photo);
  }

  @override
  Future<void> deletePhoto(
    String photoId,
  ) async {
    _photos.removeWhere(
      (item) => item.id == photoId,
    );
  }
}