import 'scenar.dart';
import 'reaction.dart';

class ScenarioRecord {
  // 🔑 jednoznačný záznam
  final String id;

  // 📜 celý scénář (pravda o scénáři)
  final Scenar scenar;

  // 💬 všechny reakce k tomuto scénáři
  final List<Reaction> reactions;

  // 🕒 kdy byl scénář vytvořen
  final DateTime createdAt;

  // 📦 archivace celého stromu
  final bool archived;

  ScenarioRecord({
    required this.id,
    required this.scenar,
    this.reactions = const [],
    DateTime? createdAt,
    this.archived = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // =========================
  // 🔄 SERIALIZACE
  // =========================
  Map<String, dynamic> toJson() => {
        'id': id,
        'scenar': scenar.toJson(),
        'reactions': reactions.map((r) => r.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'archived': archived,
      };

  factory ScenarioRecord.fromJson(Map<String, dynamic> json) {
    return ScenarioRecord(
      id: json['id'],
      scenar: Scenar.fromJson(
        Map<String, dynamic>.from(json['scenar']),
      ),
      reactions: (json['reactions'] as List? ?? [])
          .map((e) => Reaction.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      archived: json['archived'] ?? false,
    );
  }

  // =========================
  // ✏️ KOPIE (úpravy bez ztráty historie)
  // =========================
  ScenarioRecord copyWith({
    Scenar? scenar,
    List<Reaction>? reactions,
    bool? archived,
  }) {
    return ScenarioRecord(
      id: id,
      scenar: scenar ?? this.scenar,
      reactions: reactions ?? this.reactions,
      createdAt: createdAt,
      archived: archived ?? this.archived,
    );
  }
}
