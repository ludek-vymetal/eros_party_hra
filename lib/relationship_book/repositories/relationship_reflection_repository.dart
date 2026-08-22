import '../models/relationship_reflection.dart';

abstract class RelationshipReflectionRepository {
  Future<List<RelationshipReflection>> getReflections(
    String chapterId,
  );

  Stream<List<RelationshipReflection>> watchReflections(
    String chapterId,
  );

  Future<void> saveReflection(
    RelationshipReflection reflection,
  );

  Future<void> deleteReflection(
    String reflectionId,
  );
}