import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/cloud_partner_scenario.dart';

import '../services/cloud_partner_reaction_service.dart';
import '../services/partner_link_service.dart';
import '../services/cloud_partner_scenario_service.dart';
import '../models/reaction.dart';
import '../services/scenario_record_storage.dart';
import '../models/scenar.dart';
import '../models/scenario_record.dart';

class CloudPartnerScenarioDetailScreen extends StatelessWidget {
  final CloudPartnerScenario scenario;

  const CloudPartnerScenarioDetailScreen({
    super.key,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.scenarioDetail,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario.nazev,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              switch (scenario.status) {
                'completed' => l10n.completed,
                'postponed' => l10n.postponedStatus,
                'rejected' => l10n.rejectedStatus,
                _ => l10n.receivedStatus,
              },
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
            if (scenario.status == 'rejected')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.rejectedScenarioInfo,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await CloudPartnerScenarioService.updateScenarioStatus(
                          scenario.id,
                          'postponed',
                        );

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.reactionSent,
                            ),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: Text(
                        l10n.reconsiderScenario,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            if (scenario.status == 'received' ||
                scenario.status == 'postponed')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final controller = TextEditingController();
                    String selectedStatus = 'completed';

                    final result = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (_) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text(
                                l10n.sendReactionTitle,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButtonFormField<String>(
                                    initialValue: selectedStatus,
                                    decoration: InputDecoration(
                                      labelText: l10n.reactionDecision,
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'completed',
                                        child: Text(
                                          l10n.reactionComplete,
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'postponed',
                                        child: Text(
                                          l10n.reactionPostpone,
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'rejected',
                                        child: Text(
                                          l10n.reactionReject,
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedStatus = value ?? 'completed';
                                      });
                                    },
                                  ),
                                  TextField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: l10n.reactionMessage,
                                    ),
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    l10n.cancel,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, {
                                      'message': controller.text,
                                      'status': selectedStatus,
                                    });
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

                    if (!context.mounted) {
                      return;
                    }

                    final message = result['message'] as String;
                    final status = result['status'] as String;

                    if (message.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.reactionMessageRequired,
                          ),
                        ),
                      );

                      return;
                    }

                    final partnerUid =
                        await PartnerLinkService.getPartnerUid();

                    if (!context.mounted) {
                      return;
                    }

                    if (partnerUid == null) {
                      return;
                    }

                    

                    await CloudPartnerReactionService.sendReaction(
                      receiverUid: partnerUid,
                      scenarioName: scenario.nazev,
                      scenarioId: scenario.parentScenarioId,
                      message: message.trim(),
                      completed: status == 'completed',
                    );

                    debugPrint('2 REACTION SENT');

                    await CloudPartnerScenarioService.updateScenarioStatus(
                      scenario.id,
                      status,
                    );

                    debugPrint('3 STATUS UPDATED');

                    final localScenar = Scenar(
                      id: scenario.id,
                      autor: '',
                      pro: '',
                      nazev: scenario.nazev,
                      cil: '',
                      text: scenario.text,
                      hranice: '',
                      emoce: [],
                    );

                    await ScenarioRecordStorage.add(
                      ScenarioRecord(
                        id: scenario.id,
                        parentScenarioId: scenario.parentScenarioId,
                        scenar: localScenar,
                      ),
                    );

                    await ScenarioRecordStorage.addReaction(
                      scenario.parentScenarioId,
                      Reaction(
                        scenarioId: scenario.parentScenarioId,
                        nazev: scenario.nazev,
                        stav: status,
                        vzkaz: message.trim(),
                        datum: DateTime.now(),
                      ),
                    );

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.reactionSent,
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: Text(
                    l10n.reactToScenario,
                  ),
                ),
              ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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