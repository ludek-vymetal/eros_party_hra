/// Informace o scénáři, který vytvořil tuto vzpomínku.
class MemoryScenario {
  final String scenarioId;

  final String parentScenarioId;

  final String title;

  final String description;

  final String status;

  final DateTime createdAt;

  const MemoryScenario({
    required this.scenarioId,
    required this.parentScenarioId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });
}