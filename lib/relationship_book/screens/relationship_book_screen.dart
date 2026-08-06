import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';
import '../repositories/firestore_relationship_book_repository.dart';
import '../repositories/local/local_relationship_photo_repository.dart';
import '../repositories/cloud/cloud_relationship_reflection_repository.dart';
import '../services/relationship_photo_service.dart';
import '../services/relationship_reflection_service.dart';

import '../book_builder.dart';
import '../../screens/add_relationship_photo_screen.dart';
import 'relationship_book_viewer_screen.dart';
import 'relationship_trash_screen.dart';

class RelationshipBookScreen extends StatefulWidget {
  final FirestoreRelationshipBookRepository repository;
  final RelationshipPhotoService photoService;
  final RelationshipReflectionService reflectionService;

  RelationshipBookScreen({
    super.key,
    FirestoreRelationshipBookRepository? repository,
    RelationshipPhotoService? photoService,
    RelationshipReflectionService? reflectionService,
  })  : repository = repository ?? FirestoreRelationshipBookRepository(),
        photoService = photoService ??
            RelationshipPhotoService(
              repository: LocalRelationshipPhotoRepository(),
            ),
        reflectionService = reflectionService ??
            RelationshipReflectionService(
              repository: CloudRelationshipReflectionRepository(),
            );

  @override
  State<RelationshipBookScreen> createState() =>
      _RelationshipBookScreenState();
}

class _RelationshipBookScreenState
    extends State<RelationshipBookScreen> {

  late Future<List<RelationshipChapter>> _memoriesFuture;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  void _loadMemories() {
    _memoriesFuture = widget.repository.getAllMemories();
  }

  void _refreshMemories() {
    setState(() {
      _loadMemories();
    });
  }

  Future<void> _onChapterTapped(
    BuildContext context,
    RelationshipChapter chapter,
    List<RelationshipChapter> allChapters,
  ) async {
    // Optional: Show a loading dialog if fetches take noticeable time
    final photos = await widget.photoService.getPhotos(chapter.id);
    final reflections = await widget.reflectionService.getReflections(chapter.id);

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RelationshipBookViewerScreen(
          spreads: BookBuilder.build(
            chapters: allChapters,
            photos: photos,
            myReflection: reflections.isNotEmpty ? reflections.first : null,
            partnerReflection:
                reflections.length > 1 ? reflections[1] : null,
            onAddPhoto: (chapterId) async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddRelationshipPhotoScreen(
                    chapterId: chapterId,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (!mounted) return;
    _refreshMemories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relationship Book'),
        actions: [
          IconButton(
            tooltip: 'Koš',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RelationshipTrashScreen(),
                ),
              );

              if (!mounted) return;
              _refreshMemories();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<RelationshipChapter>>(
        future: _memoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                title: Text(chapter.chapterTitle),
                subtitle: Text(
                  chapter.introduction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _onChapterTapped(context, chapter, chapters),
              );
            },
          );
        },
      ),
    );
  }
}