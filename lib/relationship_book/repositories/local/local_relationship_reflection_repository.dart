import '../relationship_reflection_repository.dart';
import '../../models/relationship_reflection.dart';

class LocalRelationshipReflectionRepository
    implements RelationshipReflectionRepository {
  static final List<RelationshipReflection> _reflections = [];

  @override
  Future<List<RelationshipReflection>> getReflections(
    String chapterId,
  ) async {
    return _reflections
        .where(
          (reflection) =>
              reflection.chapterId == chapterId,
        )
        .toList();
  }

  @override
  Stream<List<RelationshipReflection>> watchReflections(
    String chapterId,
  ) async* {
    yield await getReflections(
      chapterId,
    );
  }

  @override
  Future<void> saveReflection(
    RelationshipReflection reflection,
  ) async {
    _reflections.removeWhere(
      (item) => item.id == reflection.id,
    );

    _reflections.add(
      reflection,
    );
  }

  @override
  Future<void> deleteReflection(
    String reflectionId,
  ) async {
    _reflections.removeWhere(
      (item) => item.id == reflectionId,
    );
  }
}