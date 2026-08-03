import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../services/relationship_service.dart';
import '../../models/relationship_photo.dart';
import '../relationship_photo_repository.dart';

class CloudRelationshipPhotoRepository
    implements RelationshipPhotoRepository {
  static final FirebaseStorage _storage =
      FirebaseStorage.instance;

  @override
  Future<List<RelationshipPhoto>> getPhotos(
    String chapterId,
  ) async {
    final relationshipBook =
        await RelationshipService.relationshipBook();

    final snapshot = await relationshipBook
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
    final storageRef = _storage
        .ref()
        .child(
          'relationship_book/${photo.chapterId}/${photo.id}.jpg',
        );

    await storageRef.putFile(
      imageFile,
    );

    final downloadUrl =
        await storageRef.getDownloadURL();

    final savedPhoto = photo.copyWith(
      storagePath: storageRef.fullPath,
      downloadUrl: downloadUrl,
    );

    final relationshipBook =
        await RelationshipService.relationshipBook();

    await relationshipBook
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
    final snapshot = await FirebaseFirestore.instance
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