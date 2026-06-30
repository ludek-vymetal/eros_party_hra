import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/relationship_chapter.dart';
import '../services/relationship_journal_storage.dart';

class RelationshipJournalScreen extends StatelessWidget {
  const RelationshipJournalScreen({
    super.key,
  });

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
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(
                    Icons.menu_book,
                    color: Colors.amber,
                  ),
                  title: Text(
                    chapter.chapterTitle,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    '${chapter.createdAt.day}.${chapter.createdAt.month}.${chapter.createdAt.year}',
                    style: const TextStyle(
                      color: Colors.white54,
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