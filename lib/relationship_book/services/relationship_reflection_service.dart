import '../models/relationship_reflection.dart';
import '../repositories/relationship_reflection_repository.dart';

class RelationshipReflectionService {
  final RelationshipReflectionRepository repository;

  const RelationshipReflectionService({
    required this.repository,
  });

  Future<List<RelationshipReflection>> getReflections(
    String chapterId,
  ) {
    return repository.getReflections(
      chapterId,
    );
  }

  Future<void> saveReflection(
    RelationshipReflection reflection,
  ) {
    return repository.saveReflection(
      reflection,
    );
  }

  Future<void> deleteReflection(
    String reflectionId,
  ) {
    return repository.deleteReflection(
      reflectionId,
    );
  }
}