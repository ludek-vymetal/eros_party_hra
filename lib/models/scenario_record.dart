import 'scenar.dart';
import 'reaction.dart';

class ScenarioRecord {
  final String id;
  final String parentScenarioId;
  final Scenar scenar;
  final List<Reaction> reactions;
  final DateTime createdAt;
  final bool archived;
  
  // Přidáme tato dvě pole jako volitelná
  final String senderUid;
  final String receiverUid;

  ScenarioRecord({
    required this.id,
    required this.scenar,
    this.reactions = const [],
    DateTime? createdAt,
    this.archived = false,
    String? parentScenarioId,
    this.senderUid = '', // Výchozí hodnota
    this.receiverUid = '', // Výchozí hodnota
  })  : parentScenarioId = parentScenarioId ?? id,
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'parentScenarioId': parentScenarioId,
        'scenar': scenar.toJson(),
        'reactions': reactions.map((r) => r.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'archived': archived,
        'senderUid': senderUid, // Uložíme do databáze
        'receiverUid': receiverUid,
      };

  factory ScenarioRecord.fromJson(Map<String, dynamic> json) {
    return ScenarioRecord(
      id: json['id'],
      parentScenarioId: json['parentScenarioId'] ?? json['id'],
      scenar: Scenar.fromJson(Map<String, dynamic>.from(json['scenar'])),
      reactions: (json['reactions'] as List? ?? [])
          .map((e) => Reaction.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      archived: json['archived'] ?? false,
      senderUid: json['senderUid'] ?? '', // Načtení s výchozí hodnotou
      receiverUid: json['receiverUid'] ?? '',
    );
  }

  ScenarioRecord copyWith({
    Scenar? scenar,
    List<Reaction>? reactions,
    bool? archived,
    String? parentScenarioId,
    String? senderUid,
    String? receiverUid,
  }) {
    return ScenarioRecord(
      id: id,
      parentScenarioId: parentScenarioId ?? this.parentScenarioId,
      scenar: scenar ?? this.scenar,
      reactions: reactions ?? this.reactions,
      createdAt: createdAt,
      archived: archived ?? this.archived,
      senderUid: senderUid ?? this.senderUid,
      receiverUid: receiverUid ?? this.receiverUid,
    );
  }
}