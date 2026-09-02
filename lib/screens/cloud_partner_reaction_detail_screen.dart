import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../models/cloud_partner_reaction.dart';
import '../services/cloud_partner_reaction_service.dart';
import '../../l10n/app_localizations.dart';

class CloudPartnerReactionDetailScreen extends StatelessWidget {
  final CloudPartnerReaction reaction;

  const CloudPartnerReactionDetailScreen({
    super.key,
    required this.reaction,
  });

  @override
  Widget build(BuildContext context) {
    final myUid =
        FirebaseAuth.instance.currentUser!.uid;

    final l10n =
        AppLocalizations.of(context);

    // ==========================================================
    // KDO SCÉNÁŘ SPLNIL?
    //
    // senderUid reakce = člověk, který scénář splnil
    // ==========================================================

    final isCompleter =
        myUid == reaction.senderUid;

    // ==========================================================
    // KDO JE AUTOR PŮVODNÍHO SCÉNÁŘE?
    //
    // receiverUid reakce = člověk, který reakci přijal
    // ==========================================================

    final isScenarioAuthor =
        myUid == reaction.receiverUid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.reactionDetail,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================================================
            // STAV SCÉNÁŘE
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: reaction.completed
                    ? Colors.green.withValues(
                        alpha: 0.15,
                      )
                    : Colors.red.withValues(
                        alpha: 0.15,
                      ),

                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: Row(
                children: [

                  Icon(
                    reaction.completed
                        ? Icons.check_circle
                        : Icons.cancel,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    reaction.completed
                        ? l10n.reactionCompleted
                        : l10n.reactionNotCompleted,

                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // ZPRÁVA
            // ==================================================

            Text(
              l10n.reactionMessageLabel,
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              reaction.message,
              style:
                  const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // DATUM
            // ==================================================

            Text(
              l10n.reactionDateLabel,
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              reaction.datumFormatted,
            ),

            const SizedBox(height: 24),

            // ==================================================
            // DŮKAZ JEŠTĚ NEODESLÁN
            // ==================================================

            if (!reaction.proofSent &&
                reaction.completed)

              Row(
                children: [

                  const Icon(
                    Icons.hourglass_top,
                    color: Colors.orange,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    isCompleter
                        ? '⏳ Pošli důkaz partnerovi přes WhatsApp'
                        : '⏳ Čekáš na důkaz od partnera',
                  ),
                ],
              ),

            // ==================================================
            // DŮKAZ BYL OZNAČEN JAKO ODESLANÝ
            // ==================================================

            if (reaction.proofSent &&
                !reaction.proofAccepted)

              Row(
                children: [

                  const Icon(
                    Icons.photo_camera,
                    color: Colors.orange,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    isCompleter
                        ? '📷 Důkaz byl odeslán přes WhatsApp'
                        : '📷 Partner odeslal důkaz přes WhatsApp',
                  ),
                ],
              ),

            // ==================================================
            // DŮKAZ POTVRZEN
            // ==================================================

            if (reaction.proofAccepted)

              Row(
                children: [

                  const Icon(
                    Icons.verified,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    '✅ Důkaz byl potvrzen',
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // ==================================================
            // TLAČÍTKO:
            // SPLNITEL POTVRZUJE ODESLÁNÍ PŘES WHATSAPP
            // ==================================================

            if (isCompleter &&
                reaction.completed &&
                !reaction.proofSent)

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.send,
                  ),

                  label: const Text(
                    'Důkaz jsem odeslal přes WhatsApp',
                  ),

                  onPressed: () async {

                    final confirm =
                        await showDialog<bool>(
                      context: context,

                      builder: (context) {
                        return AlertDialog(

                          title:
                              const Text(
                            'Potvrzení',
                          ),

                          content:
                              const Text(
                            'Potvrzuješ, že jsi důkaz odeslal partnerovi přes WhatsApp?',
                          ),

                          actions: [

                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  false,
                                );
                              },

                              child:
                                  const Text(
                                'Ne',
                              ),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  true,
                                );
                              },

                              child:
                                  const Text(
                                'Ano',
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm != true) {
                      return;
                    }

                    await CloudPartnerReactionService
                        .markProofSent(
                      reaction.correlationId,
                    );

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Důkaz byl označen jako odeslaný přes WhatsApp.',
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                ),
              ),

            // ==================================================
            // TLAČÍTKO:
            // AUTOR SCÉNÁŘE POTVRZUJE PŘIJETÍ DŮKAZU
            // ==================================================

            if (isScenarioAuthor &&
                reaction.proofSent &&
                !reaction.proofAccepted)

              Padding(
                padding:
                    const EdgeInsets.only(
                  top: 12,
                ),

                child: SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(

                    icon: const Icon(
                      Icons.check_circle,
                    ),

                    label: const Text(
                      'Důkaz jsem přijal přes WhatsApp',
                    ),

                    onPressed: () async {

                      await CloudPartnerReactionService
                          .acceptProof(
                        reaction.correlationId,
                      );

                      if (!context.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Důkaz byl potvrzen.',
                          ),
                        ),
                      );

                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}