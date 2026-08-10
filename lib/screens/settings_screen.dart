import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/partner_link_service.dart';
import '../services/relationship_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  bool _loggingOut = false;

  Future<void> _logout() async {
    if (_loggingOut) {
      return;
    }

    setState(() {
      _loggingOut = true;
    });

    try {
      // 1. Odpojíme lokálního partnera.
      //
      // Maže pouze:
      // - partner_code
      // - partner_uid
      // - starý relationship_id
      //
      // Nemazáme vlastní účet ani vlastní partnerCode.
      await PartnerLinkService.unlink();

      // 2. Vyčistíme aktivní Relationship.
      //
      // Je důležité, aby po odhlášení
      // další účet nepoužil Relationship
      // předchozího účtu.
      await RelationshipService
          .clearActiveRelationship();

      // 3. Odhlásíme Firebase účet.
      //
      // Vlastní Firebase účet ani jeho
      // trvalý partnerCode nemažeme.
      await FirebaseAuth.instance.signOut();

      // AuthWrapper zachytí signOut přes
      // authStateChanges() a zobrazí LoginScreen.
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loggingOut = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Odhlášení se nepodařilo: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              l10n.account,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              '${l10n.emailAddress}: ${user?.email ?? "-"}',
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _loggingOut
                        ? null
                        : _logout,
                child:
                    _loggingOut
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            l10n.logout,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}