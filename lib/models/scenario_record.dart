import 'scenar.dart';
import 'reaction.dart';

class ScenarioRecord {
  // 🔑 jednoznačný záznam
  final String id;

  // ❤️ ID celé rodiny scénářů
  final String parentScenarioId;

  // 📜 celý scénář
  final Scenar scenar;

  // 💬 reakce
  final List<Reaction> reactions;

  // 🕒 datum vytvoření
  final DateTime createdAt;

  // 📦 archivace
  final bool archived;

  ScenarioRecord({
    required this.id,
    required this.scenar,
    this.reactions = const [],
    DateTime? createdAt,
    this.archived = false,
    String? parentScenarioId,
  })  : parentScenarioId = parentScenarioId ?? id,
        createdAt = createdAt ?? DateTime.now();

  // =========================
  // 🔄 SERIALIZACE
  // =========================
  Map<String, dynamic> toJson() => {
        'id': id,
        'parentScenarioId': parentScenarioId,
        'scenar': scenar.toJson(),
        'reactions': reactions.map((r) => r.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'archived': archived,
      };

  factory ScenarioRecord.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScenarioRecord(
      id: json['id'],

      // kompatibilita se starými scénáři
      parentScenarioId:
          json['parentScenarioId'] ?? json['id'],

      scenar: Scenar.fromJson(
        Map<String, dynamic>.from(
          json['scenar'],
        ),
      ),

      reactions:
          (json['reactions'] as List? ?? [])
              .map(
                (e) => Reaction.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(),

      createdAt: DateTime.tryParse(
            json['createdAt'] ?? '',
          ) ??
          DateTime.now(),

      archived:
          json['archived'] ?? false,
    );
  }

  // =========================
  // ✏️ COPY
  // =========================
  ScenarioRecord copyWith({
    Scenar? scenar,
    List<Reaction>? reactions,
    bool? archived,
    String? parentScenarioId,
  }) {
    return ScenarioRecord(
      id: id,
      parentScenarioId:
          parentScenarioId ?? this.parentScenarioId,
      scenar: scenar ?? this.scenar,
      reactions: reactions ?? this.reactions,
      createdAt: createdAt,
      archived: archived ?? this.archived,
    );
  }
}