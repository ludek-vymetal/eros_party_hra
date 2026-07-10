import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';
import '../widgets/event_tile.dart';
import '../widgets/story_section.dart';
import '../models/chapter_status.dart';
import '../widgets/reflection_card.dart';

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

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.brown.shade300,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'KAPITOLA ${chapterNumber.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.brown.shade600,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Icon(
                        Icons.menu_book_rounded,
                        color: Colors.brown.shade700,
                        size: 34,
                      ),

                      const SizedBox(height: 14),

                      Text(
                        chapter.chapterTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade900,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        chapter.scenario.title,
                        style: TextStyle(
                          color: Colors.brown.shade500,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                if (chapter.introduction.isNotEmpty)
               
                StorySection(
                  icon: Icons.chat_bubble_outline,
                  title: 'Naše pohledy',
                  child: Column(
                    children: [

                      ReflectionCard(
                        icon: Icons.person,
                        author: 'Já',
                        text:
                            'Tady bude moje vzpomínka na tento okamžik.',
                      ),

                      ReflectionCard(
                        icon: Icons.favorite,
                        author: 'Partner',
                        text:
                            'Tady bude partnerčina vzpomínka.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                StorySection(
                  icon: Icons.emoji_events_rounded,
                  title: 'Výzva, která to všechno začala',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        chapter.scenario.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade900,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        chapter.scenario.description,
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.8,
                          color: Colors.brown.shade800,
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 24),

                StorySection(
                  icon: Icons.emoji_events_rounded,
                  title: 'Výzva, která to všechno začala',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        chapter.scenario.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade900,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        chapter.scenario.description,
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.8,
                          color: Colors.brown.shade800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                StorySection(
                  icon: Icons.favorite_rounded,
                  title: 'O této kapitole',
                  child: Column(
                    children: [

                      _infoRow(
                        Icons.calendar_today,
                        'Vytvořeno',
                        '${chapter.createdAt.day}. '
                        '${chapter.createdAt.month}. '
                        '${chapter.createdAt.year}',
                      ),

                      const SizedBox(height: 18),

                      _infoRow(
                        Icons.favorite,
                        'Oblíbená',
                        chapter.favorite
                            ? 'Ano'
                            : 'Ne',
                      ),

                      const SizedBox(height: 18),

                      _infoRow(
                        Icons.flag,
                        'Stav',
                        _statusText(
                          chapter.status,
                        ),
                      ),
                    ],
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

     

        Widget _infoRow(
          IconData icon,
          String title,
          String value,
        ) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.brown.shade700,
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.brown.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.brown.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        String _statusText(
          ChapterStatus status,
        ) {
          switch (status) {
            case ChapterStatus.draft:
              return '✍️ Píšeme ji';

            case ChapterStatus.waitingForPartner:
              return '💛 Čeká na partnera';

            case ChapterStatus.completed:
              return '💚 Dokončeno';

            case ChapterStatus.archived:
              return '📚 Archivováno';
          }

          return '';
        }
      }
     