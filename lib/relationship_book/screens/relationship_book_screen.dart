import 'package:flutter/material.dart';

import '../../screens/add_relationship_photo_screen.dart';
import '../book_builder.dart';
import '../models/relationship_chapter.dart';
import '../models/relationship_reflection.dart';
import '../repositories/cloud/cloud_relationship_reflection_repository.dart';
import '../repositories/firestore_relationship_book_repository.dart';
import '../repositories/local/local_relationship_photo_repository.dart';

import '../services/relationship_photo_service.dart';
import '../services/relationship_reflection_service.dart';
import 'relationship_book_viewer_screen.dart';
import 'relationship_trash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class _RelationshipBookScreenState extends State<RelationshipBookScreen> {
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
    final navigator = Navigator.of(context);

    final photos = await widget.photoService.getPhotos(chapter.id);
    final reflections =
        await widget.reflectionService.getReflections(chapter.id);

    if (!mounted) return;

    await navigator.push(
      MaterialPageRoute(
        builder: (_) => RelationshipBookViewerScreen(
          repository: widget.repository,
          initialIndex: allChapters.indexOf(chapter),
          spreads: BookBuilder.build(
            chapters: allChapters,
            photos: photos,
            myReflection:
                reflections.isNotEmpty ? reflections.first : null,
            partnerReflection:
                reflections.length > 1 ? reflections[1] : null,
            pageController: PageController(),
            onAddPhoto: (chapterId) async {
              await navigator.push(
                MaterialPageRoute(
                  builder: (_) =>
                      AddRelationshipPhotoScreen(chapterId: chapterId),
                ),
              );
            },
            onAddReflection: (chapterId) async {
              final controller = TextEditingController();
              final text = await showDialog<String>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Tvůj vzkaz'),
                  content: TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'Napiš, jak jsi tento okamžik prožíval/a ty...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Zrušit'),
                    ),
                    FilledButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext, controller.text),
                      child: const Text('Uložit'),
                    ),
                  ],
                ),
              );

              if (text != null && text.trim().isNotEmpty) {
                final now = DateTime.now();
                final currentUserId =
                    FirebaseAuth.instance.currentUser?.uid ?? '';

                final reflection = RelationshipReflection(
                  id: now.millisecondsSinceEpoch.toString(),
                  chapterId: chapterId,
                  authorId: currentUserId,
                  text: text.trim(),
                  createdAt: now,
                  updatedAt: now,
                );

                await widget.reflectionService.saveReflection(reflection);
                if (!mounted) return;
                _refreshMemories();
              }
            },
          ),
          chapters: allChapters,
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
              final navigator = Navigator.of(context);
              await navigator.push(
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