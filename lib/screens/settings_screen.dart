import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/partner_link_service.dart';

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
      // 1. Smažeme lokální párování.
      await PartnerLinkService.unlink();

      // 2. Smažeme vlastní párovací kód.
      //    Při dalším přihlášení se vytvoří nový.
      await PartnerLinkService.resetMyCode();

      // 3. Odhlásíme Firebase účet.
      await FirebaseAuth.instance.signOut();

      // AuthWrapper automaticky zjistí,
      // že uživatel není přihlášen,
      // a zobrazí LoginScreen.
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