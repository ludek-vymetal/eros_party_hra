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
          l10n.cloudInbox,
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
              snapshot.data!;

          if (reactions.isEmpty) {
            return Center(
              child: Text(
                l10n.noCloudScenarios,
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
                  title: Text(
                    reaction.message,
                    maxLines: 1,
                    overflow:
                        TextOverflow
                            .ellipsis,
                  ),
                  subtitle: Text(
                    reaction.datumFormatted,
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