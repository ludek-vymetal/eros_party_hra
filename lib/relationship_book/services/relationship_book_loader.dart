import '../models/relationship_book_page.dart';

import '../repositories/firestore_relationship_book_repository.dart';
import '../repositories/local/local_relationship_photo_repository.dart';
import '../repositories/cloud/cloud_relationship_reflection_repository.dart';

import 'relationship_photo_service.dart';
import 'relationship_reflection_service.dart';

class RelationshipBookLoader {
  final FirestoreRelationshipBookRepository repository =
      FirestoreRelationshipBookRepository();

  final RelationshipPhotoService photoService =
      RelationshipPhotoService(
    repository: LocalRelationshipPhotoRepository(),
  );

  final RelationshipReflectionService reflectionService =
      RelationshipReflectionService(
    repository: CloudRelationshipReflectionRepository(),
  );

  Future<List<RelationshipBookPage>> load() async {
    final chapters = await repository.getAllMemories();

    final List<RelationshipBookPage> pages = [];

    for (final chapter in chapters) {
      final photos = await photoService.getPhotos(
        chapter.id,
      );

      final reflections =
          await reflectionService.getReflections(
        chapter.id,
      );

      pages.add(
        RelationshipBookPage(
          chapter: chapter,
          photos: photos,
          myReflection:
              reflections.isNotEmpty
                  ? reflections.first
                  : null,
          partnerReflection:
              reflections.length > 1
                  ? reflections[1]
                  : null,
        ),
      );
    }

    return pages;
  }
}