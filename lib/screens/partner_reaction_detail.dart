import 'package:flutter/material.dart';
import '../models/reaction.dart';

class PartnerReactionDetailScreen extends StatelessWidget {
  final Reaction reaction;

  const PartnerReactionDetailScreen({
    super.key,
    required this.reaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12080c),
      appBar: AppBar(
        title: const Text('Detail reakce'),
        backgroundColor: const Color(0xFF12080c),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== NÁZEV SCÉNÁŘE =====
            Text(
              reaction.nazev,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // ===== STAV =====
            Text(
              'Stav: ${reaction.stav}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 6),

            // ===== EMOCE =====
            Text(
              'Emoce: ${reaction.emoce ?? '-'}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 6),

            // ===== DATUM =====
            Text(
              'Datum: ${reaction.datumFormatted}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),

            // ===== FOTO (jen informace – web) =====
            if (reaction.photoPath != null) ...[
              const SizedBox(height: 20),
              const Text(
                '📷 Fotodůkaz je dostupný v mobilní aplikaci',
                style: TextStyle(color: Colors.white70),
              ),
            ],

            // ===== VZKAZ =====
            if (reaction.vzkaz != null && reaction.vzkaz!.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Vzkaz:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                reaction.vzkaz!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],

            const Spacer(),

            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('← Zpět'),
            ),
          ],
        ),
      ),
    );
  }
}
