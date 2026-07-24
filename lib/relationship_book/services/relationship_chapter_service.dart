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
}