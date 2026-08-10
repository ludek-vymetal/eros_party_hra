import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../services/cloud_partner_service.dart';
import '../services/relationship_service.dart';
import '../services/partner_link_service.dart';

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

  final TextEditingController controller =
      TextEditingController();

  bool linked = false;
  bool loading = true;
  bool linking = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // ==========================================================
  // LOAD
  // ==========================================================

  Future<void> _load() async {
    try {
      final code =
          await PartnerLinkService.getOrCreateMyCode();

      final relationship =
          await RelationshipService
              .getActiveRelationship();

      if (!mounted) return;

      setState(() {
        myCode = code;
        linked = relationship != null;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Chyba při načítání propojení: $e',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // LINK
  // ==========================================================

  Future<void> _linkPartner() async {
    if (linking) {
      return;
    }

    final code =
        controller.text.trim().toUpperCase();

    if (code.isEmpty) {
      return;
    }

    if (code == myCode) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nemůžeš použít svůj vlastní kód.',
          ),
        ),
      );

      return;
    }

    setState(() {
      linking = true;
    });

    try {
      // ------------------------------------------------------
      // 1. Najdeme Firebase UID partnera
      // ------------------------------------------------------

      final partnerUid =
          await CloudPartnerService
              .findPartnerUid(code);

      if (partnerUid == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kód "$code" nebyl nalezen.',
            ),
          ),
        );

        return;
      }

      // ------------------------------------------------------
      // 2. Vytvoříme / najdeme Relationship
      // ------------------------------------------------------

      final relationship =
          await RelationshipService
              .getOrCreateRelationship(
        partnerUid: partnerUid,
      );

      // ------------------------------------------------------
      // 3. Nastavíme aktivní Relationship
      // ------------------------------------------------------

      await RelationshipService
          .setActiveRelationship(
        relationship.id,
      );

      // ------------------------------------------------------
      // 4. Starší lokální cache
      // ------------------------------------------------------

      await PartnerLinkService.savePartnerCode(
        code,
      );

      await PartnerLinkService.savePartnerUid(
        partnerUid,
      );

      // Cloud cache partnera
      await CloudPartnerService.savePartnerUid(
        partnerUid,
      );

      if (!mounted) return;

      setState(() {
        linked = true;
        linking = false;
        controller.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Partner byl úspěšně propojen.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Propojení se nepodařilo: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          linking = false;
        });
      }
    }
  }

  // ==========================================================
  // UNLINK
  // ==========================================================

  Future<void> _unlink() async {
    try {
      // Aktivní Relationship odstraníme z tohoto zařízení.
      await RelationshipService
          .clearActiveRelationship();

      // Vyčistíme starou lokální cache.
      await PartnerLinkService.unlink();

      if (!mounted) return;

      setState(() {
        linked = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Partner byl odpojen.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Odpojení se nepodařilo: $e',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ==========================================================
  // UI
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context);

    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.partnerLink,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.partnerLink,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: linked
            ? Column(
                children: [
                  Text(
                    l10n.linkedSuccess,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(
                    onPressed:
                        _unlink,
                    child: Text(
                      l10n.unlink,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.yourCode,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  SelectableText(
                    myCode ?? '...',
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Text(
                    l10n.enterPartnerCode,
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  TextField(
                    controller: controller,
                    textCapitalization:
                        TextCapitalization
                            .characters,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          linking
                              ? null
                              : _linkPartner,
                      child: linking
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l10n.link,
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}