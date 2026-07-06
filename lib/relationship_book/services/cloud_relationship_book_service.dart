import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/relationship_chapter.dart';

class CloudRelationshipBookService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection('relationship_book');

  static Future<void> createChapter(
    RelationshipChapter chapter,
  ) async {
    await _collection.add(
      chapter.toJson(),
    );
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getChapter(
    String documentId,
  ) async {
    return await _collection.doc(documentId).get();
  }

  static Future<void> updateChapter(
    String documentId,
    RelationshipChapter chapter,
  ) async {
    await _collection.doc(documentId).update(
      chapter.toJson(),
    );
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>
      getAllChapters() async {
    return await _collection.get();
  }

  static Future<void> deleteChapter(
    String documentId,
  ) async {
    await _collection.doc(documentId).delete();
  }
}