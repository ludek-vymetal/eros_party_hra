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

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        border: Border.all(
          color: BookTheme.accent.withValues(
            alpha: 0.25,
          ),
        ),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            author,
            style: TextStyle(
              color: BookTheme.title,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            text,
            style: TextStyle(
              color: BookTheme.body,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}