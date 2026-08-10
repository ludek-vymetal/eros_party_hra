import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../screens/add_relationship_photo_screen.dart';
import '../book_builder.dart';
import '../engine/chapter_engine.dart';
import '../models/relationship_chapter.dart';
import '../models/relationship_photo.dart';
import '../models/relationship_reflection.dart';
import '../repositories/cloud/cloud_relationship_reflection_repository.dart';
import '../repositories/firestore_relationship_book_repository.dart';
import '../repositories/local/local_relationship_photo_repository.dart';
import '../services/partner_service.dart';
import '../services/permission_service.dart';
import '../services/relationship_chapter_service.dart';
import '../services/relationship_photo_service.dart';
import '../services/relationship_reflection_service.dart';
import '../theme/book_theme.dart';
import '../widgets/book_pager.dart';
import '../widgets/chapter_motto_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RelationshipChapterScreen extends StatefulWidget {
  final RelationshipChapter chapter;
  final int chapterNumber;
  final List<RelationshipChapter> chapters;
  final int currentIndex;

  const RelationshipChapterScreen({
    super.key,
    required this.chapter,
    required this.chapterNumber,
    required this.chapters,
    required this.currentIndex,
  });

  @override
  State<RelationshipChapterScreen> createState() =>
      _RelationshipChapterScreenState();
}

class _RelationshipChapterScreenState
    extends State<RelationshipChapterScreen> {
  // Přidán PageController pro ovládání přetáčení stránek
  late final PageController _pageController;

  final RelationshipReflectionService _reflectionService =
      RelationshipReflectionService(
    repository: CloudRelationshipReflectionRepository(),
  );

  RelationshipReflection? _myReflection;
  RelationshipReflection? _partnerReflection;

  final RelationshipPhotoService _photoService = RelationshipPhotoService(
    repository: LocalRelationshipPhotoRepository(),
  );

  List<RelationshipPhoto> _photos = [];

  final ChapterEngine _chapterEngine = ChapterEngine(
    repository: FirestoreRelationshipBookRepository(),
  );
  final RelationshipChapterService _chapterService =
      RelationshipChapterService();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
    _loadReflection();
    _loadPhotos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadReflection() async {
    final reflections = await _reflectionService.getReflections(
      widget.chapter.id,
    );

    if (!mounted) return;

    setState(() {
      _myReflection = reflections.cast<RelationshipReflection?>().firstWhere(
            (item) => item != null && PartnerService.isMine(item.authorId),
            orElse: () => null,
          );

      _partnerReflection =
          reflections.cast<RelationshipReflection?>().firstWhere(
                (item) =>
                    item != null && !PartnerService.isMine(item.authorId),
                orElse: () => null,
              );
    });
  }

  Future<void> _loadPhotos() async {
    final photos = await _photoService.getPhotos(
      widget.chapter.id,
    );

    if (!mounted) return;

    setState(() {
      _photos = photos;
    });
  }

  Future<void> _deletePhoto(RelationshipPhoto photo) async {
    if (!PermissionService.canDeletePhoto(photo)) {
      return;
    }

    final delete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Smazat fotografii?'),
        content: const Text('Opravdu chcete tuto fotografii odstranit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Zrušit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Smazat'),
          ),
        ],
      ),
    );

    if (delete != true) {
      return;
    }

    await _photoService.deletePhoto(photo.id);
    await _loadPhotos();
  }

  Widget _buildMottoWhisper(String motto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.brown.shade200),
      ),
      child: Text(
        "✨ $motto",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.brown.shade800,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mottoText = (widget.chapter.customMotto != null &&
            widget.chapter.customMotto!.trim().isNotEmpty)
        ? widget.chapter.customMotto!
        : "Tak co... čím ho nebo ji překvapíš příště?";

    return Scaffold(
      backgroundColor: BookTheme.background,
      appBar: AppBar(
        backgroundColor: BookTheme.background,
        elevation: 0,
        title: Text(l10n.relationshipBook),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'motto') {
                final motto = await showDialog<String>(
                  context: context,
                  builder: (_) => const ChapterMottoDialog(),
                );

                if (motto == null) return;

                await _chapterEngine.updateMotto(
                  chapterId: widget.chapter.id,
                  customMotto: motto,
                );

                if (!mounted) return;

                setState(() {});
              } else if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Smazat kapitolu?'),
                    content: const Text(
                        'Opravdu chcete odstranit tuto kapitolu?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Zrušit'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Smazat'),
                      ),
                    ],
                  ),
                );

                if (confirm != true) return;

                await _chapterService.deleteChapter(widget.chapter.id);

                if (!context.mounted) return;

                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'motto',
                child: Text('✨ Přidat motto'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'favorite',
                child: Text('❤️ Oblíbená'),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Text('📦 Archivovat'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: Text('🗑 Smazat kapitolu'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildMottoWhisper(mottoText),
                const SizedBox(height: 16),
                Expanded(
                  child: BookPager(
                    // Pokud má váš BookPager parametr controller, předáme ho zde
                     
                    spreads: BookBuilder.build(
                      chapters: widget.chapters,
                      photos: _photos,
                      myReflection: _myReflection,
                      partnerReflection: _partnerReflection,
                      pageController: _pageController, // Předáno do BookBuilderu
                      onAddReflection: (chapterId) async {
                        final controller = TextEditingController(
                          text: _myReflection?.text ?? '',
                        );

                        final text = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
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
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Zrušit'),
                              ),
                              FilledButton(
                                onPressed: () =>
                                    Navigator.pop(context, controller.text),
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

                          await _reflectionService
                              .saveReflection(reflection);
                          await _loadReflection();
                        }
                      },
                      onAddPhoto: (chapterId) async {
                        final navigator = Navigator.of(context);
                        final saved = await navigator.push<bool>(
                          MaterialPageRoute(
                            builder: (_) => AddRelationshipPhotoScreen(
                              chapterId: chapterId,
                            ),
                          ),
                        );

                        if (saved == true) {
                          await _loadPhotos();
                        }
                      },
                    ),
                  ),
                ),
                if (_photos.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePhoto(_photos.first),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}