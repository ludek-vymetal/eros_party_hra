class Reaction {
  // 🔑 vazba na scénář
  final String scenarioId;
  final String nazev;

  // 🔥 ID reakce z Firebase (proti duplicitám)
  final String? remoteId;

  // 🧭 rozhodnutí
  final String stav;

  // ❤️ emoce při čtení / reakci
  final String? emoce;

  // 💬 osobní zpráva
  final String? vzkaz;

  // ⚖️ zpětná vazba na scénář
  final String? hodnoceni;

  // 📷 důkaz (mobil)
  final String? photoPath;

  // 🕒 čas reakce
  final DateTime datum;

  // 📦 archivace celé linie
  final bool archived;

  Reaction({
    required this.scenarioId,
    required this.nazev,
    this.remoteId,
    required this.stav,
    this.emoce,
    this.vzkaz,
    this.hodnoceni,
    this.photoPath,
    required this.datum,
    this.archived = false,
  });

  // =========================
  // 🔄 SERIALIZACE
  // =========================
  Map<String, dynamic> toJson() => {
        'scenarioId': scenarioId,
        'nazev': nazev,
        'remoteId': remoteId,
        'stav': stav,
        'emoce': emoce,
        'vzkaz': vzkaz,
        'hodnoceni': hodnoceni,
        'photoPath': photoPath,
        'datum': datum.toIso8601String(),
        'archived': archived,
      };

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      scenarioId: json['scenarioId'],
      nazev: json['nazev'],
      remoteId: json['remoteId'],
      stav: json['stav'] ?? 'odeslano',
      emoce: json['emoce'],
      vzkaz: json['vzkaz'],
      hodnoceni: json['hodnoceni'],
      photoPath: json['photoPath'],
      datum: DateTime.parse(json['datum']),
      archived: json['archived'] ?? false,
    );
  }

  // =========================
  // 🕒 FORMÁT DATA
  // =========================
  String get datumFormatted =>
      '${datum.day}.${datum.month}.${datum.year} '
      '${datum.hour}:${datum.minute.toString().padLeft(2, '0')}';
}