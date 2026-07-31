import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/relationship_service.dart';
import '../models/relationship_chapter.dart';

class CloudRelationshipBookService {
  static Future<void> createChapter(
    RelationshipChapter chapter,
  ) async {
    final collection =
        await RelationshipService.relationshipBook();

    await collection.doc(chapter.id).set(
      chapter.toJson(),
    );
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getChapter(
    String documentId,
  ) async {
    final collection =
        await RelationshipService.relationshipBook();

    return await collection.doc(documentId).get();
  }

  static Future<void> updateChapter(
    String documentId,
    RelationshipChapter chapter,
  ) async {
    final collection =
        await RelationshipService.relationshipBook();

    await collection.doc(documentId).update(
      chapter.toJson(),
    );
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllChapters() async {
    final collection =
        await RelationshipService.relationshipBook();

    return await collection.get();
  }

  static Future<void> deleteChapter(
    String documentId,
  ) async {
    final collection =
        await RelationshipService.relationshipBook();

    await collection.doc(documentId).delete();
  }
}