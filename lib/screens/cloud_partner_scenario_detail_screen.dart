import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/cloud_partner_scenario.dart';

import '../services/cloud_partner_reaction_service.dart';
import '../services/partner_link_service.dart';

import '../services/cloud_partner_scenario_service.dart';



class CloudPartnerScenarioDetailScreen
    extends StatelessWidget {
  final CloudPartnerScenario scenario;

  const CloudPartnerScenarioDetailScreen({
    super.key,
    required this.scenario,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.scenarioDetail,
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
              height: 16,
            ),

            Text(
              '${l10n.sentAt}: '
              '${scenario.createdAt.day}.${scenario.createdAt.month}.${scenario.createdAt.year}',
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
              scenario.text,
            ),

            const SizedBox(
              height: 32,
            ),

            // 💬 REAGOVAT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final controller =
                      TextEditingController();
                      String selectedStatus =
                          'completed';
                      

                  final result =
                      await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (_) {
                      return StatefulBuilder(
                        builder: (
                          context,
                          setState,
                        ) {
                          return AlertDialog(
                            title: Text(
                              l10n.sendReactionTitle,
                            ),
                            content: Column(
                              mainAxisSize:
                                  MainAxisSize.min,
                              children: [
                                DropdownButtonFormField<String>(
                                  initialValue: 'completed',
                                  decoration:
                                      const InputDecoration(
                                    labelText: 'Rozhodnutí',
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'completed',
                                      child: Text(
                                        '✅ Splním',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'postponed',
                                      child: Text(
                                        '⏳ Odložím',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 'rejected',
                                      child: Text(
                                        '❌ Odmítnu',
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    selectedStatus =
                                        value ??
                                        'completed';
                                  },
                                ),

                                TextField(
                                  controller:
                                      controller,
                                  decoration:
                                      InputDecoration(
                                    hintText:
                                        l10n.reactionMessage,
                                  ),
                                  maxLines: 3,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: Text(
                                  l10n.cancel,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    {
                                      'message':
                                          controller.text,
                                      'status':
                                          selectedStatus,
                                    },
                                  );
                                },
                                child: Text(
                                  l10n.send,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );

                  if (result == null) {
                    return;
                  }

                  final message =
                      result['message']
                          as String;

                  final status =
                      result['status']
                          as String;

                  if (message.trim().isEmpty) {
                    return;
                  }

                  final partnerUid =
                      await PartnerLinkService
                          .getPartnerUid();

                  if (partnerUid == null) {
                    return;
                  }
                  await CloudPartnerScenarioService
                      .updateScenarioStatus(
                    scenario.id,
                    status,
                  );

                  await CloudPartnerReactionService
                      .sendReaction(
                    receiverUid: partnerUid,
                    scenarioId: scenario.id,
                    message: message.trim(),
                    completed:
                      status ==
                          'completed',
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.reactionSent,
                      ),
                    ),
                  );
                },
                                child: Text(
                  l10n.reactToScenario,
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            // ❌ ZAVŘÍT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: Text(
                  l10n.close,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}