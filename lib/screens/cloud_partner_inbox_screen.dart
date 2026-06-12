
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../l10n/app_localizations.dart';
import '../services/cloud_partner_scenario_service.dart';

import 'cloud_partner_scenario_detail_screen.dart';

class CloudPartnerInboxScreen
    extends StatefulWidget {
  const CloudPartnerInboxScreen({
    super.key,
  });

  @override
  State<CloudPartnerInboxScreen>
      createState() =>
          _CloudPartnerInboxScreenState();
}

class _CloudPartnerInboxScreenState
    extends State<
        CloudPartnerInboxScreen> {
  String selectedStatus =
      'received';

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.cloudInbox,
        ),
      ),
      body: StreamBuilder(
        stream:
            CloudPartnerScenarioService
                .incomingScenarios(
          FirebaseAuth
              .instance
              .currentUser!
              .uid,
        ),
        builder: (
          context,
          snapshot,
        ) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final allScenarios =
              snapshot.data!;

          final receivedCount =
              allScenarios
                  .where(
                    (s) =>
                        s.status ==
                        'received',
                  )
                  .length;

          final postponedCount =
              allScenarios
                  .where(
                    (s) =>
                        s.status ==
                        'postponed',
                  )
                  .length;

          final completedCount =
              allScenarios
                  .where(
                    (s) =>
                        s.status ==
                        'completed',
                  )
                  .length;

          final rejectedCount =
              allScenarios
                  .where(
                    (s) =>
                        s.status ==
                        'rejected',
                  )
                  .length;

          final scenarios =
              allScenarios
                  .where(
                    (scenario) =>
                        scenario.status ==
                        selectedStatus,
                  )
                  .toList();

          return Column(
            children: [
              SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton(
                      '${l10n.inboxReceived} ($receivedCount)',
                      'received',
                    ),

                    _buildFilterButton(
                      '${l10n.inboxPostponed} ($postponedCount)',
                      'postponed',
                    ),

                    _buildFilterButton(
                      '${l10n.inboxCompleted} ($completedCount)',
                      'completed',
                    ),

                    _buildFilterButton(
                      '${l10n.inboxRejected} ($rejectedCount)',
                      'rejected',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: scenarios.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noCloudScenarios,
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            scenarios.length,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          final scenario =
                              scenarios[index];

                          return Card(
                            margin:
                                const EdgeInsets.all(
                              8,
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CloudPartnerScenarioDetailScreen(
                                      scenario:
                                          scenario,
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                scenario.nazev,
                              ),
                              subtitle: Text(
                                scenario.text,
                                maxLines: 2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterButton(
    String text,
    String status,
  ) {
    return Padding(
      padding:
          const EdgeInsets.all(
        4,
      ),
      child: ChoiceChip(
        label: Text(
          text,
        ),
        selected:
            selectedStatus ==
                status,
        onSelected: (_) {
          setState(() {
            selectedStatus =
                status;
          });
        },
      ),
    );
  }
}
