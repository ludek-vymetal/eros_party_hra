import '../models/scenar.dart';
import '../models/reaction.dart';
import '../models/scenario_record.dart';

import '../party/services/reaction_storage.dart';

import 'scenario_storage.dart';
import 'scenario_record_storage.dart';

// ⚠️ Pokud už reaction_storage.dart neexistuje,
// smaž tento import a použij nový storage/service.


class ScenarioRecordMigration {
  // =========================
  // 🚚 HLAVNÍ MIGRACE
  // =========================
  static Future<void> migrate() async {
    try {
      // 1️⃣ načteme stará data
      final List<Scenar> scenare =
          await ScenarioStorage.loadScenarios();

      final List<Reaction> reakce =
          await ReactionStorage.loadReactions();

      // 2️⃣ seskupíme reakce podle scenarioId
      final Map<String, List<Reaction>>
          reactionsByScenario = {};

      for (final r in reakce) {
        reactionsByScenario.putIfAbsent(
          r.scenarioId,
          () => [],
        );

        reactionsByScenario[r.scenarioId]!.add(r);
      }

      // 3️⃣ vytvoříme ScenarioRecord
      final List<ScenarioRecord> records = [];

      for (final s in scenare) {
        final List<Reaction> list =
            reactionsByScenario[s.id] ?? [];

        list.sort(
          (a, b) => a.datum.compareTo(b.datum),
        );

        records.add(
          ScenarioRecord(
            id: s.id,
            scenar: s,
            reactions: list,
            createdAt: s.createdAt,
            archived: s.archived,
          ),
        );
      }

      // 4️⃣ uložíme nové záznamy
      await ScenarioRecordStorage.save(records);
    } catch (e) {
      // debug log
      // ignore: avoid_print
      print(
        '❌ Scenario migration error: $e',
      );
    }
  }
}