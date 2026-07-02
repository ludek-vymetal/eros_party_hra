import '../models/relationship_memory.dart';

/// Repository pro Relationship Book.
///
/// Obrazovky nikdy nekomunikují přímo s Firestore.
/// Veškerá práce s daty probíhá přes tuto vrstvu.
abstract class RelationshipBookRepository {
  Future<List<RelationshipMemory>> getAllMemories();

  Future<RelationshipMemory?> getMemory(String id);

  Future<void> saveMemory(RelationshipMemory memory);

  Future<void> updateMemory(RelationshipMemory memory);

  Future<void> deleteMemory(String id);
}