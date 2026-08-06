import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/relationship_chapter.dart';
import '../services/relationship_journal_storage.dart';
import '../relationship_book/screens/relationship_book_screen.dart';

class RelationshipJournalScreen extends StatefulWidget {
  const RelationshipJournalScreen({
    super.key,
  });

  @override
  State<RelationshipJournalScreen> createState() =>
      _RelationshipJournalScreenState();
}

class _RelationshipJournalScreenState
    extends State<RelationshipJournalScreen> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF12080c),
      appBar: AppBar(
        title: Text(l10n.relationshipJournal),
        backgroundColor: const Color(0xFF12080c),
      ),
      body: FutureBuilder<List<RelationshipChapter>>(
        future: RelationshipJournalStorage.getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final chapters = snapshot.data!;

          if (chapters.isEmpty) {
            return Center(
              child: Text(
                l10n.relationshipJournalEmpty,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];

              return Card(
                color: const Color(0xFF1f0d14),
                margin: const EdgeInsets.only(bottom: 18),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RelationshipBookScreen(),
                      ),
                    );

                    if (!mounted) return;

                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📖 ${index + 1}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          chapter.chapterTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '${chapter.createdAt.day}.${chapter.createdAt.month}.${chapter.createdAt.year}',
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),

                        if (chapter.introduction.isNotEmpty) ...[
                          const SizedBox(height: 14),

                          Text(
                            chapter.introduction,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ],

                        const SizedBox(height: 18),

                        const Divider(),

                        const SizedBox(height: 8),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.menu_book,
                              color: Colors.amber,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Otevřít kapitolu',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
                      );
        },
      ),
    );
  }
}