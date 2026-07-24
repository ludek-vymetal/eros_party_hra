import 'dart:io';

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
    final snapshot = await _collection
        .doc(chapterId)
        .collection('photos')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();

    return snapshot.docs
        .map(
          (doc) => RelationshipPhoto.fromJson(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<void> deletePhotosForChapter(
    String chapterId,
  ) async {
    // TODO: Cloud implementace
  }

  @override
  Future<void> savePhoto(
    RelationshipPhoto photo,
    File imageFile,
  ) async {
    print("REPOSITORY START");

    final storageRef = _storage
        .ref()
        .child(
          'relationship_book/${photo.chapterId}/${photo.id}.jpg',
        );

    print(storageRef.fullPath);

    print("PUT FILE");

    await storageRef.putFile(
      imageFile,
    );

    print("GET URL");

    final downloadUrl =
        await storageRef.getDownloadURL();

    final savedPhoto = photo.copyWith(
      storagePath: storageRef.fullPath,
      downloadUrl: downloadUrl,
    );

    await _collection
        .doc(photo.chapterId)
        .collection('photos')
        .doc(photo.id)
        .set(
          savedPhoto.toJson(),
        );
  }

  @override
  Future<void> deletePhoto(
    String photoId,
  ) async {
    final snapshot = await _firestore
        .collectionGroup('photos')
        .where(
          'id',
          isEqualTo: photoId,
        )
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return;
    }

    final doc = snapshot.docs.first;

    final photo = RelationshipPhoto.fromJson(
      doc.data(),
    );

    if (photo.storagePath.isNotEmpty) {
      await _storage
          .ref(
            photo.storagePath,
          )
          .delete();
    }

    await doc.reference.delete();
  }
}