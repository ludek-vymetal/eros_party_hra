/// Informace o scénáři, který vytvořil tuto vzpomínku.
class RelationshipScenario {
  final String scenarioId;

  final String parentScenarioId;

  final String title;

  final String description;

  final String status;

  final DateTime createdAt;

  const RelationshipScenario({
    required this.scenarioId,
    required this.parentScenarioId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'scenarioId': scenarioId,
      'parentScenarioId': parentScenarioId,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RelationshipScenario.fromJson(
    Map<String, dynamic> json,
  ) {
    return RelationshipScenario(
      scenarioId: json['scenarioId'],
      parentScenarioId: json['parentScenarioId'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}