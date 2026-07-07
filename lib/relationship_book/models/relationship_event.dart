enum RelationshipEventType {
  chapterCreated,
  scenarioAccepted,
  scenarioRejected,
  scenarioCompleted,
  noteAdded,
  photoAdded,
  videoAdded,
  voiceAdded,
  chapterEdited,
}

class RelationshipEvent {
  final String id;

  final RelationshipEventType type;

  final DateTime createdAt;

  final String authorUid;

  final String description;

  const RelationshipEvent({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.authorUid,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'authorUid': authorUid,
      'description': description,
    };
  }

  factory RelationshipEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipEvent(
      id: json['id'] as String,
      type: RelationshipEventType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      authorUid: json['authorUid'] as String,
      description: json['description'] as String,
    );
  }
}