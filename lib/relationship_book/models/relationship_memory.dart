import 'memory_participant.dart';
import 'memory_scenario.dart';

/// Jedna společná kapitola Relationship Book.
///
/// Obsahuje scénář, účastníky a společné informace
/// o jedné vzpomínce.
class RelationshipMemory {
  final String id;

  final List<MemoryParticipant> participants;

  final MemoryScenario scenario;

  final String chapterTitle;

  final String introduction;

  final bool favorite;

  final DateTime createdAt;

  final DateTime updatedAt;

  const RelationshipMemory({
    required this.id,
    required this.participants,
    required this.scenario,
    required this.chapterTitle,
    required this.introduction,
    required this.favorite,
    required this.createdAt,
    required this.updatedAt,
  });
}