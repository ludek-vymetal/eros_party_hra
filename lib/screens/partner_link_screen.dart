import 'package:flutter/material.dart';


import '../../l10n/app_localizations.dart';

import '../services/partner_link_service.dart';
import '../services/cloud_partner_service.dart';
import '../services/relationship_service.dart';

class PartnerLinkScreen extends StatefulWidget {
  const PartnerLinkScreen({
    super.key,
  });

  @override
  State<PartnerLinkScreen> createState() =>
      _PartnerLinkScreenState();
}

class _PartnerLinkScreenState
    extends State<PartnerLinkScreen> {
  String? myCode;

  final controller =
      TextEditingController();

  bool linked = false;

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<void> _load() async {
    final code =
      await PartnerLinkService.getOrCreateMyCode();

  await CloudPartnerService.registerMyCode(
    code,
  );


  final isLinked =
      await PartnerLinkService.isLinked();

    if (!mounted) return;

    setState(() {
      myCode = code;
      linked = isLinked;
    });
  }
  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.partnerLink,
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),

        child: linked
            ? Column(
                children: [
                  Text(
                    l10n.linkedSuccess,
                    style:
                        const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(
                    onPressed:
                        () async {
                      await PartnerLinkService
                          .unlink();

                      await _load();
                    },
                    child: Text(
                      l10n.unlink,
                    ),
                  ),

                 
                ],
              )
            : Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    l10n.yourCode,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  SelectableText(
                    myCode ?? '...',
                    style:
                        const TextStyle(
                      fontSize: 24,
                      letterSpacing:
                          2,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Text(
                    l10n
                        .enterPartnerCode,
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  TextField(
                    controller:
                        controller,
                    textCapitalization:
                        TextCapitalization
                            .characters,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  ElevatedButton(
                    onPressed:
                        () async {
                      final code =
                          controller
                              .text
                              .trim()
                              .toUpperCase();

                      if (code
                          .isEmpty) {
                        return;
                      }

                      final partnerUid =
                          await CloudPartnerService
                              .findPartnerUid(
                        code,
                      );

                      if (partnerUid ==
                          null) {
                        return;
                      }

                      await PartnerLinkService.savePartnerCode(
                        code,
                      );

                      // Najde existující vztah nebo vytvoří nový
                      final relationship =
                          await RelationshipService.getOrCreateRelationship(
                        partnerUid: partnerUid,
                      );

                      // Nastaví aktivní vztah
                      await RelationshipService.setActiveRelationship(
                        relationship.id,
                      );

                      // Uloží Relationship ID (zatím kvůli kompatibilitě)
                      await PartnerLinkService.saveRelationshipId(
                        relationship.id,
                      );

                      // Starý systém zatím ponecháme
                      await PartnerLinkService.savePartnerUid(
                        partnerUid,
                      );

                      await CloudPartnerService.savePartnerUid(
                        partnerUid,
                      );

                      await _load();
                    },
                    child: Text(
                      l10n.link,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  
                   
                ],
              ),
      ),
    );
  }
}