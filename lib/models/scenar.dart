class Scenar {
  final String id;               // 🔑 trvalé ID
  final String autor;
  final String pro;
  final String nazev;
  final String cil;              // 🎯 PROČ scénář vznikl
  final String text;
  final String hranice;
  final List<String> emoce;
  final List<String> ocekavanaReakce; // 🤍 návrh odpovědi
  final DateTime createdAt;      // 🕒 kdy vznikl
  final bool archived;           // 📦 archiv

  Scenar({
    required this.id,
    required this.autor,
    required this.pro,
    required this.nazev,
    required this.cil,
    required this.text,
    required this.hranice,
    required this.emoce,
    this.ocekavanaReakce = const [],
    DateTime? createdAt,
    this.archived = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // =========================
  // 🔄 SERIALIZACE
  // =========================
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'autor': autor,
      'pro': pro,
      'nazev': nazev,
      'cil': cil,
      'text': text,
      'hranice': hranice,
      'emoce': emoce,
      'ocekavanaReakce': ocekavanaReakce,
      'createdAt': createdAt.toIso8601String(),
      'archived': archived,
    };
  }

  factory Scenar.fromJson(Map<String, dynamic> json) {
    return Scenar(
      id: json['id'],
      autor: json['autor'] ?? '',
      pro: json['pro'] ?? '',
      nazev: json['nazev'] ?? '',
      cil: json['cil'] ?? '',
      text: json['text'] ?? '',
      hranice: json['hranice'] ?? '',
      emoce: List<String>.from(json['emoce'] ?? []),
      ocekavanaReakce:
          List<String>.from(json['ocekavanaReakce'] ?? []),
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      archived: json['archived'] ?? false,
    );
  }

  // =========================
  // ✏️ KOPIE (pro úpravy)
  // =========================
  Scenar copyWith({
    String? autor,
    String? pro,
    String? nazev,
    String? cil,
    String? text,
    String? hranice,
    List<String>? emoce,
    List<String>? ocekavanaReakce,
    bool? archived,
  }) {
    return Scenar(
      id: id,
      autor: autor ?? this.autor,
      pro: pro ?? this.pro,
      nazev: nazev ?? this.nazev,
      cil: cil ?? this.cil,
      text: text ?? this.text,
      hranice: hranice ?? this.hranice,
      emoce: emoce ?? this.emoce,
      ocekavanaReakce:
          ocekavanaReakce ?? this.ocekavanaReakce,
      createdAt: createdAt,
      archived: archived ?? this.archived,
    );
  }
}
