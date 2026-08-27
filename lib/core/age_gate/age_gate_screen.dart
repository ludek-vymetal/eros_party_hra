import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;

import 'age_gate_controller.dart';

class AgeGateScreen extends StatelessWidget {
  final AgeGateController controller;
  final VoidCallback onConfirmed;

  const AgeGateScreen({
    super.key,
    required this.controller,
    required this.onConfirmed,
  });

  /// Uživatel odmítl potvrdit věk.
  /// Na mobilu/desktopu appku ukončíme, na webu appku "opustit" nejde
  /// (prohlížeč to nedovolí ovlivnit spolehlivě), takže místo toho
  /// zobrazíme blokující obrazovku, ze které se nelze dostat dál.
  void _handleDecline(BuildContext context) {
    if (kIsWeb) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const _AgeGateBlockedScreen(),
        ),
        (route) => false,
      );
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Věkové omezení',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tato aplikace je určena pouze pro osoby starší 18 let.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              /// POTVRZENÍ
              ElevatedButton(
                onPressed: () async {
                  await controller.confirmAdult();
                  onConfirmed();
                },
                child: const Text('Je mi 18 let nebo více'),
              ),

              const SizedBox(height: 12),

              /// ODMÍTNUTÍ
              TextButton(
                onPressed: () => _handleDecline(context),
                child: const Text('Nejsem starší 18 let'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Zobrazí se na webu, když uživatel odmítne potvrdit věk.
/// Appku nelze na webu programově zavřít, takže místo toho
/// jen zablokujeme přístup k dalšímu obsahu.
class _AgeGateBlockedScreen extends StatelessWidget {
  const _AgeGateBlockedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Přístup byl zamítnut, protože jste nepotvrdili, že jste starší 18 let.\n\n'
              'Pro pokračování prosím zavřete tuto kartu prohlížeče.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}