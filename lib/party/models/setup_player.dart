import 'player.dart';

/// Dočasný model používaný jen při nastavování nové party hry
class SetupPlayer {
  String name;
  Gender gender;
  List<String> clothes;

  SetupPlayer({
    required this.name,
    required this.gender,
    required this.clothes,
  });

  /// Validace POUZE jména (oblečení se řeší později)
  bool get isValid => name.trim().isNotEmpty;
}
