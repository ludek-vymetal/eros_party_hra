import '../../models/scenar.dart';
import '../models/relationship_scenario.dart';

class RelationshipScenarioMapper {
  const RelationshipScenarioMapper._();

  static RelationshipScenario fromScenar(
    Scenar scenar,
  ) {
    return RelationshipScenario(
      scenarioId: scenar.id,
      parentScenarioId: scenar.id,
      title: scenar.nazev,
      description: scenar.text,
      status: 'completed',
      createdAt: scenar.createdAt,
    );
  }
}