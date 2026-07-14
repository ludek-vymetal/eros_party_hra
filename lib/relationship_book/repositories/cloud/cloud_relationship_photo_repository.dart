import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/relationship_photo.dart';
import '../relationship_photo_repository.dart';

class CloudRelationshipPhotoRepository
    implements RelationshipPhotoRepository {

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseStorage _storage =
      FirebaseStorage.instance;

  static CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection(
            'relationship_book',
          );

  @override
  Future<List<RelationshipPhoto>> getPhotos(
    String chapterId,
  ) async {
    return [];
  }

  @override
  Future<void> savePhoto(
    RelationshipPhoto photo,
  ) async {}

  @override
  Future<void> deletePhoto(
    String photoId,
  ) async {}
}