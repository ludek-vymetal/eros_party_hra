import '../models/relationship_chapter.dart';

import 'relationship_book_repository.dart';
import '../services/cloud_relationship_book_service.dart';

class FirestoreRelationshipBookRepository
    implements RelationshipBookRepository {

  @override
  Future<void> saveMemory(
    RelationshipChapter memory,
  ) async {
    await CloudRelationshipBookService.saveMemory(
      memory.toJson(),
    );
  }

  @override
  Future<void> deleteMemory(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<RelationshipChapter>> getAllMemories() async {
    final snapshot =
        await CloudRelationshipBookService.getAllMemories();

    return snapshot.docs
        .map(
          (doc) => RelationshipChapter.fromJson(
            doc.data(),
          ),
        )
        .toList();
  }

  @override
  Future<RelationshipChapter?> getMemory(
    String id,
  ) async {
    final document =
        await CloudRelationshipBookService.getMemory(id);

    final data = document.data();

    if (data == null) {
      return null;
    }

    return RelationshipChapter.fromJson(data);
  }

  @override
  Future<void> updateMemory(
    RelationshipChapter memory,
  ) async {
    await CloudRelationshipBookService.updateMemory(
      memory.id,
      memory.toJson(),
    );
  }
}