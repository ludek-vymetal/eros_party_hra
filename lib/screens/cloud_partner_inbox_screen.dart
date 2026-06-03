import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../l10n/app_localizations.dart';
import '../services/cloud_partner_scenario_service.dart';

class CloudPartnerInboxScreen extends StatelessWidget {
  const CloudPartnerInboxScreen({
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

          final scenarios =
              snapshot.data!;

          

          if (scenarios.isEmpty) {
            return Center(
              child: Text(
                l10n.noCloudScenarios,
              ),
            );
          }

          return ListView.builder(
            itemCount:
                scenarios.length,

            itemBuilder:
                (
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
          );
        },
      ),
    );
  }
}