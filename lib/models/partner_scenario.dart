import 'dart:convert';

class PartnerScenario {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool archived;

  PartnerScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.archived = false,
  });

  PartnerScenario copyWith({
    String? title,
    String? description,
    bool? archived,
  }) {
    return PartnerScenario(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      archived: archived ?? this.archived,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'archived': archived,
      };

  factory PartnerScenario.fromJson(Map<String, dynamic> json) {
    return PartnerScenario(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      archived: json['archived'] ?? false,
    );
  }

  static String encodeList(List<PartnerScenario> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  static List<PartnerScenario> decodeList(String raw) =>
      (jsonDecode(raw) as List)
          .map((e) => PartnerScenario.fromJson(e))
          .toList();
}
