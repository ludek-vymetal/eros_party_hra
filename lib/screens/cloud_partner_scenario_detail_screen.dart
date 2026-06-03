import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/cloud_partner_scenario.dart';

import '../services/cloud_partner_reaction_service.dart';
import '../services/partner_link_service.dart';

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

                  final result =
                      await showDialog<String>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(
                          l10n.sendReactionTitle,
                        ),
                        content: TextField(
                          controller: controller,
                          decoration:
                              InputDecoration(
                            hintText:
                                l10n.reactionMessage,
                          ),
                          maxLines: 3,
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
                                controller.text,
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

                  if (result == null ||
                      result.trim().isEmpty) {
                    return;
                  }

                  final partnerUid =
                      await PartnerLinkService
                          .getPartnerUid();

                  if (partnerUid == null) {
                    return;
                  }

                  await CloudPartnerReactionService
                      .sendReaction(
                    receiverUid: partnerUid,
                    scenarioId: scenario.id,
                    message: result.trim(),
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