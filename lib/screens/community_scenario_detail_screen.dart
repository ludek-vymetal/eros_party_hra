import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/community_scenario.dart';
import '../models/scenar.dart';

import '../services/community_scenario_service.dart';
import '../services/scenario_storage.dart';

class CommunityScenarioDetailScreen
    extends StatelessWidget {
  final CommunityScenario scenario;

  const CommunityScenarioDetailScreen({
    super.key,
    required this.scenario,
  });

  Future<void> _importScenario(
    BuildContext context,
  ) async {
    final l10n =
        AppLocalizations.of(context);

    final existing =
        await ScenarioStorage
            .loadScenarios();

    final duplicate =
        existing.any(
      (s) =>
          s.nazev == scenario.nazev &&
          s.text == scenario.text,
    );

    if (duplicate) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            l10n.scenarioAlreadyImported,
          ),
        ),
      );

      return;
    }

    final scenar = Scenar(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      autor: scenario.autor,
      pro: scenario.pro,
      nazev: scenario.nazev,
      cil: scenario.cil,
      text: scenario.text,
      hranice: scenario.hranice,
      emoce: scenario.emoce,
    );

    await ScenarioStorage.addScenario(
      scenar,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          l10n.scenarioImported,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          scenario.nazev,
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,
          children: [
            Text(
              scenario.nazev,
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.communityScenarioAuthor}: ${scenario.autor}',
                ),
                Text(
                  '${l10n.communityScenarioFor}: ${scenario.pro}',
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.communityScenarioGoal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  scenario.cil,
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              scenario.text,
            ),

            const SizedBox(
              height: 16,
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.communityScenarioBoundaries,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  scenario.hranice,
                ),
              ],
            ),

            if (scenario
                .emoce.isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.communityScenarioEmotions,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    scenario.emoce.join(', '),
                  ),
                ],
              ),
            ],

            const SizedBox(
              height: 32,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      ElevatedButton.icon(
                    icon: const Icon(
                      Icons.thumb_up,
                    ),
                    label: Text(
                      l10n.likes,
                    ),
                    onPressed: () async {
                      await CommunityScenarioService
                          .likeScenario(
                        scenario.id,
                      );

                      if (!context
                          .mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.likes,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      ElevatedButton.icon(
                    icon: const Icon(
                      Icons.download,
                    ),
                    label: Text(
                      l10n.importScenario,
                    ),
                    onPressed: () =>
                        _importScenario(
                      context,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [
                Expanded(
                  child:
                      ElevatedButton.icon(
                    icon: const Icon(
                      Icons.flag,
                    ),
                    label: Text(
                      l10n.reportScenario,
                    ),
                    onPressed: () async {
                      await CommunityScenarioService
                          .reportScenario(
                        scenario.id,
                      );

                      if (!context
                          .mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.scenarioReported,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}