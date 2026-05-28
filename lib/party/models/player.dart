enum Gender { male, female }

class PartyPlayer {
  final String name;
  final Gender gender;
  final List<String> clothes;
  final String specialClothing;
  int completed;

  PartyPlayer({
    required this.name,
    required this.gender,
    required List<String> clothes,
    required this.specialClothing,
    this.completed = 0,
  }) : clothes = List.of(clothes);

  bool get isNaked => clothes.isEmpty;

  /// 🔥 TRUE pokud zbývá už jen prémiový kus
  bool get isLastClothing =>
      clothes.length == 1 && clothes.first == specialClothing;

  void incrementCompleted() {
    completed++;
  }

  void resetCompleted() {
    completed = 0;
  }

  /// 🎲 Ruleta svlékání
  /// - speciální oblečení jde dolů VŽDY jako poslední
  /// - dokud je víc kusů, speciální se nevybírá
  String? removeRandomClothing() {
    if (clothes.isEmpty) return null;

    // Více kusů → nikdy nesundáváme speciální
    if (clothes.length > 1 && clothes.contains(specialClothing)) {
      final options =
          clothes.where((c) => c != specialClothing).toList();
      options.shuffle();
      final removed = options.first;
      clothes.remove(removed);
      return removed;
    }

    // Poslední kus = prémiový
    return clothes.removeLast();
  }

  void addClothing(String clothing) {
    clothes.add(clothing);
  }

  // 🔽 SERIALIZACE
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender.name,
      'clothes': clothes,
      'specialClothing': specialClothing,
      'completed': completed,
    };
  }

  factory PartyPlayer.fromJson(Map<String, dynamic> json) {
    return PartyPlayer(
      name: json['name'],
      gender: Gender.values.firstWhere(
        (g) => g.name == json['gender'],
      ),
      clothes: List<String>.from(json['clothes']),
      specialClothing: json['specialClothing'],
      completed: json['completed'] ?? 0,
    );
  }
}
