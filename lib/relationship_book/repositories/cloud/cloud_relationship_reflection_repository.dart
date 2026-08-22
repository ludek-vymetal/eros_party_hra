

import '../../../services/relationship_service.dart';
import '../../models/relationship_reflection.dart';
import '../relationship_reflection_repository.dart';

class CloudRelationshipReflectionRepository
    implements RelationshipReflectionRepository {
  @override
  Future<List<RelationshipReflection>> getReflections(
    String chapterId,
  ) async {
    final relationshipBook =
        await RelationshipService.relationshipBook();

    final snapshot = await relationshipBook
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
  Stream<List<RelationshipReflection>> watchReflections(
    String chapterId,
  ) async* {
    final relationshipBook =
        await RelationshipService.relationshipBook();

    yield* relationshipBook
        .doc(chapterId)
        .collection('reflections')
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (doc) => RelationshipReflection.fromJson(
                    doc.data(),
                  ),
                )
                .toList();
          },
        );
  }

  @override
  Future<void> saveReflection(
    RelationshipReflection reflection,
  ) async {
    final relationshipBook =
        await RelationshipService.relationshipBook();

    await relationshipBook
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