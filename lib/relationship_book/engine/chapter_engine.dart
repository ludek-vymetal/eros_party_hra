import 'package:uuid/uuid.dart';

import '../models/chapter_status.dart';
import '../models/relationship_chapter.dart';
import '../models/relationship_event.dart';
import '../models/relationship_scenario.dart';
import '../repositories/relationship_book_repository.dart';
import 'package:flutter/foundation.dart';

class ChapterEngine {
  final RelationshipBookRepository repository;

  const ChapterEngine({
    required this.repository,
  });

  Future<RelationshipChapter?> getChapter(String chapterId) async {
    return await repository.getMemory(chapterId);
  }

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
    debugPrint('=================================');
    debugPrint('CREATE CHAPTER');
    debugPrint('Scenario title: ${scenario.title}');
    debugPrint('Chapter title : $chapterTitle');
    debugPrint('Intro         : $introduction');
    debugPrint('Scenario ID   : ${scenario.scenarioId}');
    debugPrint('=================================');
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

    final updated = chapter.copyWith(
      updatedAt: DateTime.now(),
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

    final updated = chapter.copyWith(
      chapterTitle: chapterTitle,
      introduction: introduction,
      updatedAt: DateTime.now(),
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