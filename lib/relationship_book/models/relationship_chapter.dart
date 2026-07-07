import 'relationship_participant.dart';
import 'relationship_scenario.dart';
import 'chapter_status.dart';
import 'relationship_event.dart';

/// Jedna společná kapitola Relationship Book.
///
/// Obsahuje scénář, účastníky a společné informace
/// o jedné vzpomínce.
class RelationshipChapter {
  final String id;

  final List<RelationshipParticipant> participants;

  final RelationshipScenario scenario;

  final String chapterTitle;

  final String introduction;

  final bool favorite;

  final DateTime createdAt;

  final DateTime updatedAt;

  final ChapterStatus status;

  final ChapterStatus status;

  const RelationshipChapter({
    required this.id,
    required this.participants,
    required this.scenario,
    required this.chapterTitle,
    required this.introduction,
    required this.favorite,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.events,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants
          .map((participant) => participant.toJson())
          .toList(),
      'events': events
          .map((event) => event.toJson())
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
  factory RelationshipChapter.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipChapter(
      id: json['id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map(
            (participant) => RelationshipParticipant.fromJson(
              participant as Map<String, dynamic>,
            ),
          )
          .toList(),
      scenario: RelationshipScenario.fromJson(
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
      events: (json['events'] as List<dynamic>)
          .map(
            (event) => RelationshipEvent.fromJson(
              event as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
  
}
    