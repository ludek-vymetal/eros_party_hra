import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cloud_relationship_chapter.dart';

class CloudRelationshipJournalService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> get _chapters =>
      _firestore.collection('relationship_journal');

  static Future<void> createChapter({
    required CloudRelationshipChapter chapter,
  }) async {
    await _chapters.add(chapter.toMap());
  }

  static Stream<List<CloudRelationshipChapter>> myChapters() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _chapters
        .where('ownerUid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(CloudRelationshipChapter.fromFirestore)
              .toList(),
        );
  }

  static Future<void> deleteChapter(
    String id,
  ) async {
    await _chapters.doc(id).delete();
  }

  static Future<void> updateFavorite(
    String id,
    bool favorite,
  ) async {
    await _chapters.doc(id).update({
      'favorite': favorite,
    });
  }
  static Future<void> createChapterForUsers({
    required CloudRelationshipChapter chapterForSender,
    required CloudRelationshipChapter chapterForReceiver,
  }) async {
    final batch = _firestore.batch();

    batch.set(
      _chapters.doc(),
      chapterForSender.toMap(),
    );

    batch.set(
      _chapters.doc(),
      chapterForReceiver.toMap(),
    );

    await batch.commit();
  }
}
