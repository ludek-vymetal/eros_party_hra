import '../models/relationship_chapter.dart';
import '../services/cloud_relationship_book_service.dart';
import 'relationship_book_repository.dart';

class FirestoreRelationshipBookRepository
    implements RelationshipBookRepository {
  @override
  Future<void> saveMemory(
    RelationshipChapter chapter,
  ) async {
    await CloudRelationshipBookService.createChapter(
      chapter,
    );
  }

  @override
  Future<void> deleteMemory(
    String id,
  ) async {
    await CloudRelationshipBookService.deleteChapter(
      id,
    );
  }

  @override
  Future<List<RelationshipChapter>> getAllMemories() async {
    final snapshot =
        await CloudRelationshipBookService.getAllChapters();

    return snapshot.docs
        .map(
          (doc) => RelationshipChapter.fromJson(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<RelationshipChapter?> getMemory(
    String id,
  ) async {
    final document =
        await CloudRelationshipBookService.getChapter(
      id,
    );

    final data = document.data();

    if (data == null) {
      return null;
    }

    return RelationshipChapter.fromJson(data);
  }

  @override
  Future<void> updateMemory(
    RelationshipChapter chapter,
  ) async {
    await CloudRelationshipBookService.updateChapter(
      chapter.id,
      chapter,
    );
  }
  @override
  Future<RelationshipChapter?> findByScenarioId(
    String scenarioId,
  ) async {
    final chapters = await getAllMemories();

    try {
      return chapters.firstWhere(
        (chapter) => chapter.scenario.scenarioId == scenarioId,
      );
    } catch (_) {
      return null;
    }
  }
}
