import '../models/relationship_chapter.dart';

/// Repository pro Relationship Book.
///
/// Obrazovky nikdy nekomunikují přímo s Firestore.
/// Veškerá práce s daty probíhá přes tuto vrstvu.
abstract class RelationshipBookRepository {
  Future<List<RelationshipChapter>> getAllMemories();
  
  Future<RelationshipChapter?> findByScenarioId(
    String scenarioId,
  );

  Future<RelationshipChapter?> getMemory(String id);

  Future<void> saveMemory(RelationshipChapter memory);

  Future<void> updateMemory(RelationshipChapter memory);

  Future<void> deleteMemory(String id);

  Future<List<RelationshipChapter>> getDeletedMemories();

  
}