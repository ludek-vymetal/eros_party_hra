import 'package:cloud_firestore/cloud_firestore.dart';

class CloudRelationshipBookService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection('relationship_book');

  static Future<void> saveMemory(
    Map<String, dynamic> data,
  ) async {
    await _collection.add(data);
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getMemory(
    String documentId,
  ) async {
    return await _collection.doc(documentId).get();
  }
  static Future<void> updateMemory(
    String documentId,
    Map<String, dynamic> data,
  ) async {
    await _collection.doc(documentId).update(data);
  }
  static Future<QuerySnapshot<Map<String, dynamic>>>
      getAllMemories() async {
    return await _collection.get();
  }
  static Future<void> deleteMemory(
    String documentId,
  ) async {
    await _collection.doc(documentId).delete();
  }
}