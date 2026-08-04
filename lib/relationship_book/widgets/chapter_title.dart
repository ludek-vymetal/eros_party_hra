import 'package:flutter/material.dart';

import '../theme/book_theme.dart';

class ChapterTitle extends StatelessWidget {
  final String chapter;
  final String title;
  final String date;

  const ChapterTitle({
    super.key,
    required this.chapter,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          chapter,
          style: TextStyle(
            color: BookTheme.accent,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          style: TextStyle(
            color: BookTheme.title,
            fontSize: 34,
            fontWeight: FontWeight.bold,
            height: 1.15,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          date,
          style: TextStyle(
            color: BookTheme.body,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),

        const SizedBox(height: 24),

        Divider(
          color: BookTheme.accent.withValues(alpha: 0.35),
          thickness: 1,
        ),
      ],
    );
  }
}