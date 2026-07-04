import 'memory_participant.dart';

import 'memory_scenario.dart';
import 'chapter_status.dart';


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

  final ChapterStatus status;

  const RelationshipMemory({
    required this.id,
    required this.participants,
    required this.scenario,
    required this.chapterTitle,
    required this.introduction,
    required this.favorite,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants
          .map((participant) => participant.toJson())
          .toList(),
      'scenario': scenario.toJson(),
      'chapterTitle': chapterTitle,
      'introduction': introduction,
      'status': status.name,
      'favorite': favorite,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  factory RelationshipMemory.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipMemory(
      id: json['id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map(
            (participant) => MemoryParticipant.fromJson(
              participant as Map<String, dynamic>,
            ),
          )
          .toList(),
      scenario: MemoryScenario.fromJson(
        json['scenario'] as Map<String, dynamic>,
      ),
      chapterTitle: json['chapterTitle'] as String,
      introduction: json['introduction'] as String,
      favorite: json['favorite'] as bool,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
      status: ChapterStatus.values.firstWhere(
        (value) => value.name == json['status'],
      ),
    );
  }
  
}
    