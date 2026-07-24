import 'package:flutter/material.dart';

class ChapterMottoDialog extends StatelessWidget {
  const ChapterMottoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F3E8),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: Colors.brown.shade700,
              size: 38,
            ),

            const SizedBox(height: 16),

            Text(
              "Motto kapitoly",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade900,
              ),
            ),

            const SizedBox(height: 20),

            Divider(
              color: Colors.brown.shade300,
            ),

            const SizedBox(height: 24),

            Text(
              "„Tak co...\nčím ho nebo ji překvapíš příště?“",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                height: 1.6,
                fontStyle: FontStyle.italic,
                color: Colors.brown.shade700,
              ),
            ),

            const SizedBox(height: 24),

            Divider(
              color: Colors.brown.shade300,
            ),

            const SizedBox(height: 20),

            Text(
              "Vyberte větu, která bude provázet tuto kapitolu vašeho příběhu.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.brown.shade600,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text("Jiné motto"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text("Vlastní motto"),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(
                    context,
                    "Tak co... čím ho nebo ji překvapíš příště?",
                  );
                },
                icon: const Icon(Icons.favorite),
                label: const Text("Použít"),
              ),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Zavřít"),
            ),
          ],
        ),
      ),
    );
  }
}