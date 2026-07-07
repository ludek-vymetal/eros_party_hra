import 'package:uuid/uuid.dart';

import '../models/chapter_status.dart';
import '../models/relationship_chapter.dart';
import '../models/relationship_scenario.dart';
import '../repositories/relationship_book_repository.dart';

class ChapterEngine {
  final RelationshipBookRepository repository;

  const ChapterEngine({
    required this.repository,
  });

  Future<void> createChapter({
    required RelationshipScenario scenario,
    required String chapterTitle,
    required String introduction,
  }) async {
    final now = DateTime.now();

    final chapter = RelationshipChapter(
      id: const Uuid().v4(),
      participants: const [],
      scenario: scenario,
      chapterTitle: chapterTitle,
      introduction: introduction,
      favorite: false,
      createdAt: now,
      updatedAt: now,
      status: ChapterStatus.draft,
    );

    await repository.saveMemory(chapter);
  }

  Future<void> updateChapter(
    RelationshipChapter chapter,
  ) async {
    await repository.updateMemory(chapter);
  }

  Future<void> deleteChapter(
    String chapterId,
  ) async {
    await repository.deleteMemory(chapterId);
  }

  Future<List<RelationshipChapter>> getAllChapters() {
    return repository.getAllMemories();
  }
}