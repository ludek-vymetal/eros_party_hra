import '../models/relationship_memory.dart';
import 'cloud_relationship_book_service.dart';
import 'relationship_book_repository.dart';
class FirestoreRelationshipBookRepository
    implements RelationshipBookRepository {

  @override
  Future<void> saveMemory(
    RelationshipMemory memory,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMemory(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<RelationshipMemory>> getAllMemories() {
    throw UnimplementedError();
  }

  @override
  Future<RelationshipMemory?> getMemory(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateMemory(RelationshipMemory memory) {
    throw UnimplementedError();
  }
}