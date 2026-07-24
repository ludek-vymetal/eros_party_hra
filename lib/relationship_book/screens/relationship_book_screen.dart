import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';
import '../repositories/firestore_relationship_book_repository.dart';
import 'relationship_chapter_screen.dart';
import 'relationship_trash_screen.dart';

class RelationshipBookScreen extends StatefulWidget {
  const RelationshipBookScreen({
    super.key,
  });

  @override
  State<RelationshipBookScreen> createState() =>
      _RelationshipBookScreenState();
}

class _RelationshipBookScreenState
    extends State<RelationshipBookScreen> {
  final FirestoreRelationshipBookRepository repository =
      FirestoreRelationshipBookRepository();

  late Future<List<RelationshipChapter>> memories;

  @override
  void initState() {
    super.initState();
    memories = repository.getAllMemories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relationship Book',
        ),
        actions: [
          IconButton(
            tooltip: 'Koš',
            icon: const Icon(
              Icons.delete_outline,
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const RelationshipTrashScreen(),
                ),
              );

              if (!mounted) {
                return;
              }

              setState(() {
                memories = repository.getAllMemories();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<RelationshipChapter>>(
        future: memories,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Chyba: ${snapshot.error}',
              ),
            );
          }

          final chapters = snapshot.data ?? [];

          if (chapters.isEmpty) {
            return const Center(
              child: Text(
                'Zatím nemáte žádné kapitoly.',
              ),
            );
          }

          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapters[index];

              return ListTile(
                title: Text(
                  chapter.chapterTitle,
                ),
                subtitle: Text(
                  chapter.introduction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RelationshipChapterScreen(
                        chapter: chapter,
                        chapterNumber: index + 1,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}