import 'package:firebase_auth/firebase_auth.dart';
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
  late final PageController _pageController;

  final RelationshipReflectionService _reflectionService =
      RelationshipReflectionService(
    repository: CloudRelationshipReflectionRepository(),
  );

  final RelationshipPhotoService _photoService = RelationshipPhotoService(
    repository: LocalRelationshipPhotoRepository(),
  );

  final ChapterEngine _chapterEngine = ChapterEngine(
    repository: FirestoreRelationshipBookRepository(),
  );

  final RelationshipChapterService _chapterService =
      RelationshipChapterService();

  late RelationshipChapter _currentChapter;

  List<RelationshipPhoto> _photos = [];

  final Map<String, List<RelationshipPhoto>> _photosByChapter = {};

  final Map<String, RelationshipReflection?> _myReflectionsByChapter = {};

  final Map<String, RelationshipReflection?> _partnerReflectionsByChapter = {};

  bool _loadingBookData = true;

  @override
  void initState() {
    super.initState();

    _currentChapter = widget.chapter;

    _pageController = PageController(
      initialPage: widget.currentIndex,
    );

    _loadBookData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ==========================================================
  // NAČTENÍ DAT CELÉ KNIHY
  // ==========================================================

  Future<void> _loadBookData() async {
    setState(() {
      _loadingBookData = true;
    });

    final photosMap = <String, List<RelationshipPhoto>>{};

    final myReflectionsMap = <String, RelationshipReflection?>{};

    final partnerReflectionsMap = <String, RelationshipReflection?>{};

    for (final currentChapter in widget.chapters) {
      final photos = await _photoService.getPhotos(
        currentChapter.id,
      );

      photosMap[currentChapter.id] = photos;

      final reflections = await _reflectionService.getReflections(
        currentChapter.id,
      );

      RelationshipReflection? myReflection;
      RelationshipReflection? partnerReflection;

      for (final reflection in reflections) {
        if (PartnerService.isMine(
          reflection.authorId,
        )) {
          myReflection ??= reflection;
        } else {
          partnerReflection ??= reflection;
        }
      }

      myReflectionsMap[currentChapter.id] = myReflection;

      partnerReflectionsMap[currentChapter.id] = partnerReflection;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _photosByChapter
        ..clear()
        ..addAll(photosMap);

      _myReflectionsByChapter
        ..clear()
        ..addAll(myReflectionsMap);

      _partnerReflectionsByChapter
        ..clear()
        ..addAll(partnerReflectionsMap);

      _photos = photosMap[_currentChapter.id] ?? [];

      _loadingBookData = false;
    });
  }

  // ==========================================================
  // OBNOVENÍ REFLEXE KONKRÉTNÍ KAPITOLY
  // ==========================================================

  Future<void> _loadReflection(
    String chapterId,
  ) async {
    final reflections = await _reflectionService.getReflections(
      chapterId,
    );

    if (!mounted) {
      return;
    }

    RelationshipReflection? myReflection;
    RelationshipReflection? partnerReflection;

    for (final reflection in reflections) {
      if (PartnerService.isMine(
        reflection.authorId,
      )) {
        myReflection ??= reflection;
      } else {
        partnerReflection ??= reflection;
      }
    }

    setState(() {
      _myReflectionsByChapter[chapterId] = myReflection;

      _partnerReflectionsByChapter[chapterId] = partnerReflection;
    });
  }

  // ==========================================================
  // OBNOVENÍ FOTOGRAFIÍ KONKRÉTNÍ KAPITOLY
  // ==========================================================

  Future<void> _loadPhotos(
    String chapterId,
  ) async {
    final photos = await _photoService.getPhotos(
      chapterId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _photosByChapter[chapterId] = photos;

      if (chapterId == _currentChapter.id) {
        _photos = photos;
      }
    });
  }

  // ==========================================================
  // SMAZÁNÍ FOTOGRAFIE
  // ==========================================================

  Future<void> _deletePhoto(
    RelationshipPhoto photo,
  ) async {
    if (!PermissionService.canDeletePhoto(
      photo,
    )) {
      return;
    }

    final delete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Smazat fotografii?',
        ),
        content: const Text(
          'Opravdu chcete tuto fotografii odstranit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              false,
            ),
            child: const Text(
              'Zrušit',
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              true,
            ),
            child: const Text(
              'Smazat',
            ),
          ),
        ],
      ),
    );

    if (delete != true) {
      return;
    }

    await _photoService.deletePhoto(
      photo.id,
    );

    await _loadPhotos(
      photo.chapterId,
    );
  }

  // ==========================================================
  // MOTTO
  // ==========================================================

  Widget _buildMottoWhisper(
    String motto,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.brown.shade200,
        ),
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

  // ==========================================================
  // PŘIDÁNÍ / ÚPRAVA REFLEXE
  // ==========================================================

  Future<void> _addReflection(
    String chapterId,
  ) async {
    final controller = TextEditingController(
      text: _myReflectionsByChapter[chapterId]?.text ?? '',
    );

    final text = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Tvůj vzkaz',
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Napiš, jak jsi tento okamžik prožíval/a ty...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              dialogContext,
            ),
            child: const Text(
              'Zrušit',
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              controller.text,
            ),
            child: const Text(
              'Uložit',
            ),
          ),
        ],
      ),
    );

    controller.dispose();

    if (text == null || text.trim().isEmpty) {
      return;
    }

    final now = DateTime.now();

    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    final existingReflection = _myReflectionsByChapter[chapterId];

    final reflection = RelationshipReflection(
      id: existingReflection?.id ?? now.millisecondsSinceEpoch.toString(),
      chapterId: chapterId,
      authorId: currentUserId,
      text: text.trim(),
      createdAt: existingReflection?.createdAt ?? now,
      updatedAt: now,
    );

    await _reflectionService.saveReflection(
      reflection,
    );

    await _loadReflection(
      chapterId,
    );
  }

  // ==========================================================
  // PŘIDÁNÍ FOTOGRAFIE
  // ==========================================================

  Future<void> _addPhoto(
    String chapterId,
  ) async {
    final navigator = Navigator.of(context);

    final saved = await navigator.push<bool>(
      MaterialPageRoute(
        builder: (_) => AddRelationshipPhotoScreen(
          chapterId: chapterId,
        ),
      ),
    );

    if (saved == true) {
      await _loadPhotos(
        chapterId,
      );
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context);

    final mottoText = (_currentChapter.customMotto != null &&
            _currentChapter.customMotto!.trim().isNotEmpty)
        ? _currentChapter.customMotto!
        : "Tak co... čím ho nebo ji překvapíš příště?";

    return Scaffold(
      backgroundColor: BookTheme.background,

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: BookTheme.background,
        elevation: 0,
        title: Text(
          l10n.relationshipBook,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'motto') {
                final motto = await showDialog<String>(
                  context: context,
                  builder: (_) => const ChapterMottoDialog(),
                );

                if (motto == null) {
                  return;
                }

                await _chapterEngine.updateMotto(
                  chapterId: _currentChapter.id,
                  customMotto: motto,
                );

                final updatedChapter = await _chapterEngine.getChapter(
                  _currentChapter.id,
                );

                if (!mounted || updatedChapter == null) {
                  return;
                }

                setState(() {
                  _currentChapter = updatedChapter;
                  widget.chapters[widget.currentIndex] = updatedChapter;
                });
              } else if (value == 'favorite') {
                await _chapterService.toggleFavorite(
                  _currentChapter,
                );

                final updatedChapter = await _chapterEngine.getChapter(
                  _currentChapter.id,
                );

                if (!mounted || updatedChapter == null) {
                  return;
                }

                setState(() {
                  _currentChapter = updatedChapter;
                  widget.chapters[widget.currentIndex] = updatedChapter;
                });
              } else if (value == 'archive') {
                await _chapterService.archiveChapter(
                  _currentChapter,
                );

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);
              } else if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      'Smazat kapitolu?',
                    ),
                    content: const Text(
                      'Opravdu chcete odstranit tuto kapitolu?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(
                          context,
                          false,
                        ),
                        child: const Text(
                          'Zrušit',
                        ),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(
                          context,
                          true,
                        ),
                        child: const Text(
                          'Smazat',
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm != true) {
                  return;
                }

                await _chapterService.deleteChapter(
                  _currentChapter.id,
                );

                if (!mounted) {
                  return;
                }

                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'motto',
                child: Text(
                  '✨ Přidat motto',
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'favorite',
                child: Text(
                  '❤️ Oblíbená',
                ),
              ),
              const PopupMenuItem(
                value: 'archive',
                child: Text(
                  '📦 Archivovat',
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: Text(
                  '🗑 Smazat kapitolu',
                ),
              ),
            ],
          ),
        ],
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildMottoWhisper(
                  mottoText,
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: _loadingBookData
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : BookPager(
                          spreads: BookBuilder.build(
                            chapters: widget.chapters,
                            photosByChapter: _photosByChapter,
                            myReflectionsByChapter: _myReflectionsByChapter,
                            partnerReflectionsByChapter:
                                _partnerReflectionsByChapter,
                            pageController: _pageController,
                            onAddReflection: _addReflection,
                            onAddPhoto: _addPhoto,
                          ),
                        ),
                ),
                if (_photos.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => _deletePhoto(
                      _photos.first,
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