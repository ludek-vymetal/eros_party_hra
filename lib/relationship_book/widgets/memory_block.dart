import 'package:flutter/material.dart';

import '../theme/book_theme.dart';

class MemoryBlock extends StatelessWidget {
  final String author;
  final String text;

  const MemoryBlock({
    super.key,
    required this.author,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.brown.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            author,
            style: TextStyle(
              color: Colors.brown.shade800,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 4),

          Divider(
            color: Colors.brown.shade300,
            thickness: .8,
            height: 10,
          ),

          const SizedBox(height: 8),

          Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: BookTheme.body,
              fontSize: 16,
              height: 1.55,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}