import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/relationship_reflection.dart';
import '../relationship_reflection_repository.dart';

class CloudRelationshipReflectionRepository
    implements RelationshipReflectionRepository {

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection(
            'relationship_book',
          );

  @override
  Future<List<RelationshipReflection>> getReflections(
    String chapterId,
  ) async {
    final snapshot = await _collection
        .doc(chapterId)
        .collection('reflections')
        .get();

    return snapshot.docs
        .map(
          (doc) => RelationshipReflection.fromJson(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<void> saveReflection(
    RelationshipReflection reflection,
  ) async {
    await _collection
        .doc(reflection.chapterId)
        .collection('reflections')
        .doc(reflection.authorId)
        .set(
          reflection.toJson(),
        );
  }

  @override
  Future<void> deleteReflection(
    String reflectionId,
  ) async {
    // Doplníme později.
  }
}