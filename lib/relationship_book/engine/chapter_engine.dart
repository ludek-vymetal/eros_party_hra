import 'package:uuid/uuid.dart';

import '../models/chapter_status.dart';
import '../models/relationship_chapter.dart';
import '../models/relationship_scenario.dart';
import '../repositories/relationship_book_repository.dart';
import '../models/relationship_event.dart';

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
      events: [
        RelationshipEvent(
          id: const Uuid().v4(),
          type: RelationshipEventType.chapterCreated,
          createdAt: now,
          authorUid: '',
          description: 'Kapitola byla vytvořena.',
        ),
      ],
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
  
  Future<RelationshipChapter?> findChapterByScenario(
    String scenarioId,
  ) {
    return repository.findByScenarioId(
      scenarioId,
    );
  }

    Future<void> createChapterFromScenario({
      required RelationshipScenario scenario,
    }) async {
      final existing = await repository.findByScenarioId(
        scenario.scenarioId,
      );

      if (existing != null) {
        return;
      }

      await createChapter(
        scenario: scenario,
        chapterTitle: scenario.title,
        introduction: '',
      );
    }

    Future<void> addEvent({
      required String scenarioId,
      required RelationshipEvent event,
    }) async {
      final chapter = await repository.findByScenarioId(
        scenarioId,
      );

      if (chapter == null) {
        return;
      }

      final updated = RelationshipChapter(
        id: chapter.id,
        participants: chapter.participants,
        scenario: chapter.scenario,
        chapterTitle: chapter.chapterTitle,
        introduction: chapter.introduction,
        favorite: chapter.favorite,
        createdAt: chapter.createdAt,
        updatedAt: DateTime.now(),
        status: chapter.status,
        events: [
          ...chapter.events,
          event,
        ],
      );

      await repository.updateMemory(updated);
    }
    Future<void> updateIntroduction({
      required String scenarioId,
      required String chapterTitle,
      required String introduction,
    }) async {
      final chapter = await repository.findByScenarioId(
        scenarioId,
      );

      if (chapter == null) {
        return;
      }

      final updated = RelationshipChapter(
        id: chapter.id,
        participants: chapter.participants,
        scenario: chapter.scenario,
        chapterTitle: chapterTitle,
        introduction: introduction,
        favorite: chapter.favorite,
        createdAt: chapter.createdAt,
        updatedAt: DateTime.now(),
        status: chapter.status,
        events: chapter.events,
      );

      await repository.updateMemory(updated);
    } 
    Future<void> updateMotto({
      required String chapterId,
      int? erosVoiceId,
      String? customMotto,
    }) async {
      final chapter = await repository.getMemory(chapterId);

      if (chapter == null) {
        return;
      }

      final updated = chapter.copyWith(
        erosVoiceId: erosVoiceId,
        customMotto: customMotto,
        updatedAt: DateTime.now(),
      );

      await repository.updateMemory(updated);
    }

  }
