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
            itemCount:
                reactions.length,
            itemBuilder:
                (
                  context,
                  index,
                ) {
              final reaction =
                  reactions[index];

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
                    reaction.completed
                        ? l10n.completed
                        : l10n.notCompleted,
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        reaction.message,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),
                      Text(
                        reaction.datumFormatted,
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
      ),
    );
  }
}