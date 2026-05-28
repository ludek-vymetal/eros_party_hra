import 'package:flutter/material.dart';
import 'dart:io';
import 'age_gate_controller.dart';

class AgeGateScreen extends StatelessWidget {
  final AgeGateController controller;
  final VoidCallback onConfirmed;

  const AgeGateScreen({
    super.key,
    required this.controller,
    required this.onConfirmed,
  });

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
                onPressed: () {
                  exit(0);
                },
                child: const Text('Nejsem starší 18 let'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
