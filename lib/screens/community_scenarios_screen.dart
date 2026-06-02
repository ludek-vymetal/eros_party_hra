import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/community_scenario.dart';
import '../services/community_scenario_service.dart';

import 'community_scenario_detail_screen.dart';

enum CommunityScenarioSort {
  latest,
  top,
}

class CommunityScenariosScreen extends StatefulWidget {
  const CommunityScenariosScreen({
    super.key,
  });

  @override
  State<CommunityScenariosScreen> createState() =>
      _CommunityScenariosScreenState();
}

class _CommunityScenariosScreenState
    extends State<CommunityScenariosScreen> {
  CommunityScenarioSort _sort =
      CommunityScenarioSort.latest;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.communityScenarios,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(12),
            child: SegmentedButton<
                CommunityScenarioSort>(
              segments: [
                ButtonSegment(
                  value:
                      CommunityScenarioSort
                          .latest,
                  label: Text(
                    l10n.latestScenarios,
                  ),
                  icon: const Icon(
                    Icons.schedule,
                  ),
                ),
                ButtonSegment(
                  value:
                      CommunityScenarioSort
                          .top,
                  label: Text(
                    l10n.topScenarios,
                  ),
                  icon: const Icon(
                    Icons.emoji_events,
                  ),
                ),
              ],
              selected: {
                _sort,
              },
              onSelectionChanged:
                  (selection) {
                setState(() {
                  _sort =
                      selection.first;
                });
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<
                List<
                    CommunityScenario>>(
              stream:
                  _sort ==
                          CommunityScenarioSort
                              .latest
                      ? CommunityScenarioService
                          .latestScenarios()
                      : CommunityScenarioService
                          .topScenarios(),
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                final scenarios =
                    snapshot.data ?? [];

                if (scenarios
                    .isEmpty) {
                  return Center(
                    child: Text(
                      l10n
                          .noCommunityScenarios,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount:
                      scenarios.length,
                  itemBuilder:
                      (
                        context,
                        index,
                      ) {
                        final scenario =
                            scenarios[index];

                        return Card(
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal:
                                12,
                            vertical:
                                6,
                          ),
                          child:
                              ListTile(
                            title: Text(
                              scenario
                                  .nazev,
                            ),
                            subtitle:
                                Text(
                              '${scenario.autor} • ❤️ ${scenario.likes}',
                            ),
                            trailing:
                                const Icon(
                              Icons
                                  .chevron_right,
                            ),
                            onTap:
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          CommunityScenarioDetailScreen(
                                    scenario:
                                        scenario,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}