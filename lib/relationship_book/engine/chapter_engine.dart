import '../models/relationship_chapter.dart';
import '../repositories/relationship_book_repository.dart';

class ChapterEngine {
  final RelationshipBookRepository repository;

  const ChapterEngine({
    required this.repository,
  });

  Future<void> createChapter(
    RelationshipChapter chapter,
  ) async {
    await repository.saveMemory(
      chapter,
    );
  }
}