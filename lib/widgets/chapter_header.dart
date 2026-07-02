import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/relationship_chapter.dart';

class ChapterHeader extends StatelessWidget {
  final RelationshipChapter chapter;
  final int chapterNumber;

  const ChapterHeader({
    super.key,
    required this.chapter,
    required this.chapterNumber,
  });

  String _roman(int number) {
    const romans = [
      '',
      'I',
      'II',
      'III',
      'IV',
      'V',
      'VI',
      'VII',
      'VIII',
      'IX',
      'X',
      'XI',
      'XII',
      'XIII',
      'XIV',
      'XV',
      'XVI',
      'XVII',
      'XVIII',
      'XIX',
      'XX',
    ];

    if (number < romans.length) {
      return romans[number];
    }

    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Text(
          'KAPITOLA ${_roman(chapterNumber)}',
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 5,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          chapter.chapterTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "${chapter.createdAt.day}.${chapter.createdAt.month}.${chapter.createdAt.year}",
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          l10n.relationshipStorySubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.italic,
            color: Colors.black54,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}