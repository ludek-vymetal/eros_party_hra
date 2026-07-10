import '../models/relationship_reflection.dart';

abstract class RelationshipReflectionRepository {
  Future<List<RelationshipReflection>> getReflections(
    String chapterId,
  );

  Future<void> saveReflection(
    RelationshipReflection reflection,
  );

  Future<void> deleteReflection(
    String reflectionId,
  );
}