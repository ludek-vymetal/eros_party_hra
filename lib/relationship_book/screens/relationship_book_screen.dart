import 'package:flutter/material.dart';
import '../repositories/firestore_relationship_book_repository.dart';
import '../models/relationship_memory.dart';

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

  late final Future<List<RelationshipMemory>> memories;

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
      ),
      body: FutureBuilder<List<RelationshipMemory>>(
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}   