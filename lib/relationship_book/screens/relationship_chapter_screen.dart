import 'dart:io';

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/relationship_chapter.dart';
import '../models/relationship_reflection.dart';
import '../widgets/reflection_card.dart';
import 'edit_relationship_reflection_screen.dart';
import '../services/relationship_reflection_service.dart';
import '../repositories/cloud/cloud_relationship_reflection_repository.dart';
import '../models/relationship_photo.dart';
import '../services/relationship_photo_service.dart';
import '../repositories/local/local_relationship_photo_repository.dart';
import '../widgets/chapter_motto_dialog.dart';
import '../engine/chapter_engine.dart';
import '../repositories/firestore_relationship_book_repository.dart';
import '../services/partner_service.dart';
import '../services/permission_service.dart';
import '../services/relationship_chapter_service.dart';
import '../theme/book_theme.dart';

import '../../screens/add_relationship_photo_screen.dart';

import '../widgets/book_pager.dart';
import '../book_builder.dart';

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
  String? _chapterMotto;

  final ChapterEngine _chapterEngine = ChapterEngine(
    repository: FirestoreRelationshipBookRepository(),
  );
  final RelationshipChapterService _chapterService =
      RelationshipChapterService();

  @override
  void initState() {
    super.initState();
    _loadReflection();
    _loadPhotos();
    _loadChapterMotto();
  }

  void _loadChapterMotto() {
    if (widget.chapter.customMotto != null &&
        widget.chapter.customMotto!.trim().isNotEmpty) {
      _chapterMotto = widget.chapter.customMotto;
      return;
    }

    _chapterMotto = "Tak co... čím ho nebo ji překvapíš příště?";
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

                setState(() {
                  _chapterMotto = motto;
                });
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
            child: BookPager(
              spreads: BookBuilder.build(
                chapters: widget.chapters,
                photos: _photos,
                myReflection: _myReflection,
                partnerReflection: _partnerReflection,
                onAddPhoto: (chapterId) async {
                  final saved = await Navigator.push<bool>(
                    context,
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
        ),
      ),
    );
  }
}