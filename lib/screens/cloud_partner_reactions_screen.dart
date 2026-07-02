import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../l10n/app_localizations.dart';

import '../services/cloud_partner_reaction_service.dart';
import 'cloud_partner_reaction_detail_screen.dart';

class CloudPartnerReactionsScreen
    extends StatelessWidget {
  const CloudPartnerReactionsScreen({
    super.key,
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
          l10n.incomingReactions,
        ),
      ),
      body: StreamBuilder(
        stream:
            CloudPartnerReactionService
                .incomingReactions(
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

          final reactions =
              List.of(snapshot.data!);

          reactions.sort(
            (a, b) => b.createdAt.compareTo(
              a.createdAt,
            ),
          );

          if (reactions.isEmpty) {
            return Center(
              child: Text(
                l10n.noIncomingReactions,
              ),
            );
          }

          return ListView.builder(
            itemCount: reactions.length,
            itemBuilder: (
              context,
              index,
            ) {
              final reaction =
                  reactions[index];
              final myUid = FirebaseAuth.instance.currentUser!.uid;

              final isCompleter = reaction.senderUid == myUid;
              final isAuthor = reaction.receiverUid == myUid;   
              assert(isCompleter || isAuthor); 
              print("MY UID: $myUid");
              print("SENDER: ${reaction.senderUid}");
              print("RECEIVER: ${reaction.receiverUid}");
              print("IS COMPLETER: $isCompleter");
              print("IS AUTHOR: $isAuthor");
              print("proofSent: ${reaction.proofSent}");
              print("proofAccepted: ${reaction.proofAccepted}");

              return Card(
                margin:
                    const EdgeInsets.all(
                  8,
                ),
                child: ListTile(
                  leading: Icon(
                    reaction.completed
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        reaction.completed
                            ? Colors.green
                            : Colors.red,
                  ),

                  title: Text(
                    l10n.scenarioLabel(
                      reaction.scenarioName,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        reaction.completed
                            ? '✅ ${l10n.completed}'
                            : '❌ ${l10n.notCompleted}',
                      ),

                      Text(
                        l10n.dateLabel(
                          reaction.datumFormatted,
                        ),
                      ),

                      if (reaction.proofAccepted)
                        Text(
                          isCompleter
                              ? l10n.proofConfirmedByPartner
                              : l10n.proofConfirmed,
                        )
                      else if (reaction.proofSent)
                        Text(
                          isCompleter
                              ? l10n.proofSent
                              : l10n.waitingProofConfirmation,
                        ),

                      if (reaction.message
                          .isNotEmpty)
                        Text(
                          l10n.messageLabel(
                            reaction.message,
                          ),
                        
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                        ),
                    ],
                  ),

                  onTap: () {
                    print("KLIKNUTO");
                    debugPrint('========== OTVIRAM DETAIL ==========');
                    debugPrint('senderUid: ${reaction.senderUid}');
                    debugPrint('receiverUid: ${reaction.receiverUid}');
                    debugPrint('proofSent: ${reaction.proofSent}');
                    debugPrint('proofAccepted: ${reaction.proofAccepted}');
                    debugPrint('correlationId: ${reaction.correlationId}');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CloudPartnerReactionDetailScreen(
                          reaction: reaction,
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
    );
  }
}