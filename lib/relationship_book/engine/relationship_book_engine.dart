import '../models/relationship_chapter.dart';
import '../repositories/relationship_book_repository.dart';

class RelationshipBookEngine {
  final RelationshipBookRepository repository;

  const RelationshipBookEngine({
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