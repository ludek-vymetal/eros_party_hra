import '../models/chapter_status.dart';
import '../models/relationship_chapter.dart';
import '../repositories/firestore_relationship_book_repository.dart';
import '../repositories/local/local_relationship_photo_repository.dart';
import 'relationship_photo_service.dart';

class RelationshipChapterService {
  final FirestoreRelationshipBookRepository _repository =
      FirestoreRelationshipBookRepository();

  final RelationshipPhotoService _photoService =
      RelationshipPhotoService(
    repository: LocalRelationshipPhotoRepository(),
  );

  Future<void> deleteChapter(
    String chapterId,
  ) async {
    final chapter = await _repository.getMemory(
      chapterId,
    );

    if (chapter == null) {
      return;
    }

    final deletedChapter = chapter.copyWith(
      isDeleted: true,
      deletedAt: DateTime.now(),
    );

    await _repository.updateMemory(
      deletedChapter,
    );
  }

  Future<void> restoreChapter(
    String chapterId,
  ) async {
    final chapter = await _repository.getMemory(
      chapterId,
    );

    if (chapter == null) {
      return;
    }

    final restoredChapter = chapter.copyWith(
      isDeleted: false,
      deletedAt: null,
    );

    await _repository.updateMemory(
      restoredChapter,
    );
  }

  Future<void> toggleFavorite(
    RelationshipChapter chapter,
  ) async {
    final updated = chapter.copyWith(
      favorite: !chapter.favorite,
      updatedAt: DateTime.now(),
    );

    await _repository.updateMemory(updated);
  }

  Future<void> archiveChapter(
    RelationshipChapter chapter,
  ) async {
    final updated = chapter.copyWith(
      status: ChapterStatus.archived,
      updatedAt: DateTime.now(),
    );

    await _repository.updateMemory(updated);
  }

  Future<void> deleteChapterForever(
    String chapterId,
  ) async {
    await _photoService.deletePhotosForChapter(
      chapterId,
    );

    // TODO
    // await _reflectionService.deleteReflectionsForChapter(chapterId);

    // TODO
    // await _timelineService.deleteTimeline(chapterId);

    // TODO
    // await _mottoService.deleteMotto(chapterId);

    await _repository.deleteMemory(
      chapterId,
    );
  }
}