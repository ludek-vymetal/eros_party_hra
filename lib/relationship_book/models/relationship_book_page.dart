import 'relationship_chapter.dart';
import 'relationship_photo.dart';
import 'relationship_reflection.dart';

class RelationshipBookPage {
  final RelationshipChapter chapter;

  final List<RelationshipPhoto> photos;

  final RelationshipReflection? myReflection;

  final RelationshipReflection? partnerReflection;

  const RelationshipBookPage({
    required this.chapter,
    required this.photos,
    required this.myReflection,
    required this.partnerReflection,
  });
}