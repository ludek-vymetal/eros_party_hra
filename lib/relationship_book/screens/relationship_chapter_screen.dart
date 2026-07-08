import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';
import '../widgets/event_tile.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF12080C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12080C),
        title: const Text(
          'Relationship Book',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F3E8),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 12,
                  offset: Offset(0, 6),
                  color: Colors.black26,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Kapitola $chapterNumber',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.brown,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    chapter.chapterTitle,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Divider(),

                const SizedBox(height: 20),

                const Text(
                  '📖 Úvod',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  chapter.introduction.isEmpty
                      ? 'Tato kapitola zatím nemá úvod.'
                      : chapter.introduction,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 20),

                const Text(
                  '❤️ Informace',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text(
                    'Oblíbená kapitola',
                  ),
                  subtitle: Text(
                    chapter.favorite ? 'Ano' : 'Ne',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text(
                    'Vytvořeno',
                  ),
                  subtitle: Text(
                    chapter.createdAt.toString(),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text(
                    'Stav',
                  ),
                  subtitle: Text(
                    chapter.status.name,
                  ),
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 20),

                const Text(
                  '🕒 Časová osa',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ...chapter.events.map(
                  (event) => EventTile(
                    event: event,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}