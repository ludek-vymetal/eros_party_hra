/// Jedna událost v časové ose kapitoly.
///
/// Díky této třídě bude možné v budoucnu
/// přidávat fotografie, videa, hlasové zprávy,
/// poznámky i časové kapsle bez změny architektury.
/// 📷 fotografie
///🎥 videa
///🎤 hlasové zprávy
///💌 časové kapsle
///🎂 výročí
///📝 společné poznámky
///❤️ připomenutí starých vzpomínek
class ChapterTimelineEntry {
  final String id;

  /// Typ události (photo, note, capsule, anniversary...)
  final String type;

  /// Krátký název události.
  final String title;

  /// Volitelný popis.
  final String description;

  /// Datum vytvoření události.
  final DateTime createdAt;

  const ChapterTimelineEntry({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
  });
}