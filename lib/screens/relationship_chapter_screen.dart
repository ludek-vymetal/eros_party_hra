import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/relationship_chapter.dart';
import '../widgets/book_divider.dart';
import '../widgets/chapter_header.dart';
import 'edit_relationship_chapter_screen.dart';

class RelationshipChapterScreen extends StatelessWidget {
  final RelationshipChapter chapter;
  final int chapterNumber;

  const RelationshipChapterScreen({
    super.key,
    required this.chapter,
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF12080c),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12080c),
        title: Text(
          l10n.relationshipStory,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditRelationshipChapterScreen(
                    chapter: chapter,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F3E8),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChapterHeader(
                chapter: chapter,
                chapterNumber: chapterNumber,
              ),

              const SizedBox(height: 20),

              if (chapter.introduction.isNotEmpty) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.introduction.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 52,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        chapter.introduction.substring(1),
                        style: const TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          height: 1.8,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],

              const BookDivider(
                icon: Icons.menu_book,
              ),

              const SizedBox(height: 18),

              Text(
                "📖 ${l10n.scenarioTitle}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                chapter.record.scenar.nazev,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                chapter.record.scenar.text,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

              if (chapter.record.reactions.isNotEmpty) ...[
                const SizedBox(height: 30),

                const BookDivider(
                  icon: Icons.favorite,
                ),

                const SizedBox(height: 18),

                Text(
                  "💬 ${l10n.reactionDetail}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ...chapter.record.reactions.map(
                  (reaction) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reaction.stav,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          reaction.vzkaz ?? '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}