import 'package:flutter/material.dart';

import '../models/cloud_partner_reaction.dart';
import '../services/cloud_partner_reaction_service.dart';
import '../../l10n/app_localizations.dart';




class CloudPartnerReactionDetailScreen
    extends StatelessWidget {
  final CloudPartnerReaction reaction;
  

  const CloudPartnerReactionDetailScreen({
    super.key,
    required this.reaction,
  });

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.reactionDetail,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(
                12,
              ),
              decoration: BoxDecoration(
                color:
                    reaction.completed
                        ? Colors.green
                            .withValues(
                            alpha: 0.15,
                          )
                        : Colors.red
                            .withValues(
                            alpha: 0.15,
                          ),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    reaction.completed
                        ? Icons.check_circle
                        : Icons.cancel,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
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

            const SizedBox(
              height: 24,
            ),

            Text(
                l10n.reactionMessageLabel,
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              reaction.message,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Text(
                    l10n.reactionDateLabel,
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              reaction.datumFormatted,
            ),

            const SizedBox(
              height: 24,
            ),

            if (reaction.proofAccepted)
              Row(
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    l10n.proofAccepted,
                  )
                ],
              )
            else if (reaction.proofSent)
              const Row(
                children: [
                  Icon(
                    Icons.photo_camera,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    '📷 Důkaz odeslán přes WhatsApp',
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(
                    Icons.hourglass_top,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    l10n.proofWaiting,
                  )
                ],
              ),

            const SizedBox(
              height: 24,
            ),

           if (reaction.completed &&
              !reaction.proofSent)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.photo_camera,
                ),
                label: Text(
                  l10n.proofSentButton,
                ),
                onPressed: () async {
                  final confirm =
                      await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          l10n.confirmation,
                        ),
                        content: Text(
                          l10n.proofSentQuestion,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                false,
                              );
                            },
                            child: Text(
                              l10n.no,
                            ),
                                                      ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            child: Text(
                              l10n.yes,
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
                    reaction.id,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.proofAcceptedSnackBar,
                      ),
                    ),
                  );

                  Navigator.pop(
                    context,
                  );
                },
              ),
            ),

          const SizedBox(
            height: 12,
          ),

            if (reaction.proofSent &&
                !reaction.proofAccepted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await CloudPartnerReactionService
                        .acceptProof(
                      reaction.id,
                    );

                    if (!context.mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          l10n.proofAcceptedSnackBar,
                        ),
                      ),
                    );

                    Navigator.pop(
                      context,
                    );
                  },
                  child: Text(
                    l10n.proofAcceptedButton,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}