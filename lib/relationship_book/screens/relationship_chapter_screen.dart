import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF12080C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12080C),
        title: Text(
          l10n.relationshipBook,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        '${l10n.chapter.toUpperCase()} ${chapterNumber.toString().padLeft(2, '0')}',
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
                    icon: Icons.auto_stories,
                    title: l10n.relationshipStory,
                    child: Text(
                      chapter.introduction,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.8,
                        fontStyle: FontStyle.italic,
                        color: Colors.brown.shade900,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
                
                StorySection(
                  icon: Icons.chat_bubble_outline,
                  title: l10n.relationshipReflections,
                  child: Column(
                    children: [
                      ReflectionCard(
                        icon: Icons.person,
                        author: l10n.me,
                        text: l10n.relationshipReflectionPlaceholderMine,
                      ),
                      ReflectionCard(
                        icon: Icons.favorite,
                        author: l10n.partner,
                        text: l10n.relationshipReflectionPlaceholderPartner,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                StorySection(
                  icon: Icons.emoji_events_rounded,
                  title: l10n.relationshipChallenge,
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
                  title: l10n.relationshipAboutChapter,
                  child: Column(
                    children: [
                      _infoRow(
                        Icons.calendar_today,
                        l10n.created,
                        _formatDate(chapter.createdAt),
                      ),
                      const SizedBox(height: 18),
                      _infoRow(
                        Icons.favorite,
                        l10n.favorite,
                        chapter.favorite ? l10n.yes : l10n.no,
                      ),
                      const SizedBox(height: 18),
                      _infoRow(
                        Icons.flag,
                        l10n.status,
                        _statusText(context, chapter.status),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                StorySection(
                  icon: Icons.history_rounded,
                  title: l10n.timeline,
                  child: chapter.events.isEmpty
                      ? Text(l10n.noEventsYet)
                      : Column(
                          children: [
                            ...chapter.events.map(
                              (event) => EventTile(
                                event: event,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
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

  String _statusText(BuildContext context, ChapterStatus status) {
    final l10n = AppLocalizations.of(context);
    return switch (status) {
      ChapterStatus.draft => l10n.chapterDraft,
      ChapterStatus.waitingForPartner => l10n.chapterWaitingForPartner,
      ChapterStatus.completed => l10n.chapterCompleted,
      ChapterStatus.archived => l10n.chapterArchived,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.day}. ${date.month}. ${date.year}';
  }
}