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
}