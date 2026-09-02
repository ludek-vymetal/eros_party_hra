import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../l10n/app_localizations.dart';

import '../models/cloud_partner_reaction.dart';
import '../services/cloud_partner_reaction_service.dart';
import '../services/relationship_service.dart';

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

      body: FutureBuilder(
        future:
            RelationshipService.getActiveRelationship(),

        builder: (
          context,
          relationshipSnapshot,
        ) {
          if (relationshipSnapshot.hasError) {
            debugPrint(
              'RELATIONSHIP ERROR: '
              '${relationshipSnapshot.error}',
            );

            return Center(
              child: Text(
                relationshipSnapshot.error.toString(),
              ),
            );
          }

          if (relationshipSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final relationship =
              relationshipSnapshot.data;

          if (relationship == null) {
            return const Center(
              child: Text(
                'Není aktivní vztah.',
              ),
            );
          }

          final relationshipId =
              relationship.id;

          debugPrint(
            '🔵 REACTIONS SCREEN',
          );

          debugPrint(
            '🔵 RELATIONSHIP ID = '
            '$relationshipId',
          );

          debugPrint(
            '🔵 MY UID = '
            '${FirebaseAuth.instance.currentUser?.uid}',
          );

          return StreamBuilder<
              List<CloudPartnerReaction>>(
            stream:
                CloudPartnerReactionService
                    .incomingReactions(
              relationshipId,
            ),

            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.hasError) {
                debugPrint(
                  '🔴 REACTION ERROR: '
                  '${snapshot.error}',
                );

                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              }

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              final reactions =
                  snapshot.data ??
                      <CloudPartnerReaction>[];

              debugPrint(
                '🟢 REACTIONS COUNT = '
                '${reactions.length}',
              );

              reactions.sort(
                (a, b) =>
                    b.createdAt.compareTo(
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
                itemCount:
                    reactions.length,

                itemBuilder: (
                  context,
                  index,
                ) {
                  final reaction =
                      reactions[index];

                  final myUid =
                      FirebaseAuth
                          .instance
                          .currentUser
                          ?.uid;

                  final isCompleter =
                      reaction.senderUid ==
                          myUid;

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
                                  ? l10n
                                      .proofConfirmedByPartner
                                  : l10n
                                      .proofConfirmed,
                            )
                          else if (reaction.proofSent)
                            Text(
                              isCompleter
                                  ? l10n.proofSent
                                  : l10n
                                      .waitingProofConfirmation,
                            ),

                          if (reaction
                              .message
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
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                CloudPartnerReactionDetailScreen(
                              reaction:
                                  reaction,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}