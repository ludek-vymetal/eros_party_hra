import '../models/relationship_chapter.dart';
import '../repositories/firestore_relationship_book_repository.dart';
import 'relationship_chapter_service.dart';

class RelationshipTrashService {
  final FirestoreRelationshipBookRepository _repository =
      FirestoreRelationshipBookRepository();

  final RelationshipChapterService _chapterService =
      RelationshipChapterService();

  Future<List<RelationshipChapter>> getTrash() {
    return _repository.getDeletedMemories();
  }

  Future<void> restoreChapter(
    String chapterId,
  ) {
    return _chapterService.restoreChapter(
      chapterId,
    );
  }
}