import 'dart:io';

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../models/relationship_chapter.dart';
import '../models/relationship_reflection.dart';
import '../widgets/event_tile.dart';
import '../widgets/story_section.dart';
import '../models/chapter_status.dart';
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
import 'relationship_photo_viewer_screen.dart';
import '../services/relationship_chapter_service.dart';
import '../theme/book_theme.dart';
import '../widgets/open_book.dart';
import '../widgets/photo_frame.dart';
import '../widgets/memory_block.dart';
import '../../screens/add_relationship_photo_screen.dart';
import '../pages/book_left_page.dart';
import '../pages/book_right_page.dart';

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

  String _pluralize(int count, String one, String few, String other) {
    if (count == 1) return "$count $one";
    if (count >= 2 && count <= 4) return "$count $few";
    return "$count $other";
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
            child: OpenBook(
              leftPage: BookLeftPage(
                chapter: widget.chapter,
                chapterNumber: widget.chapterNumber,
                motto: _chapterMotto,
              ),
              rightPage: BookRightPage(
                photos: _photos,
                myReflection: _myReflection,
                partnerReflection: _partnerReflection,
                onAddPhoto: () async {
                  final saved = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddRelationshipPhotoScreen(
                        chapterId: widget.chapter.id,
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

  Widget _buildOriginalContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final reflectionCount =
        (_myReflection != null ? 1 : 0) + (_partnerReflection != null ? 1 : 0);
    const challengeCount = 1;

    final events = [...widget.chapter.events]
      ..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
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
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.brown.shade300),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${l10n.chapter.toUpperCase()} ${widget.chapterNumber.toString().padLeft(2, '0')}',
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
                      widget.chapter.chapterTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade900,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_chapterMotto != null) ...[
                      const SizedBox(height: 24),
                      _buildMottoWhisper(_chapterMotto!),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      "${_pluralize(reflectionCount, "pohled", "pohledy", "pohledů")} · ${_pluralize(_photos.length, "fotografie", "fotografie", "fotografií")} · ${_pluralize(challengeCount, "výzva", "výzvy", "výzev")}",
                      style: TextStyle(
                        color: Colors.brown.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (widget.chapter.introduction.isNotEmpty)
                StorySection(
                  icon: Icons.auto_stories,
                  title: "Jak to začalo",
                  child: Text(
                    widget.chapter.introduction,
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
                title: "Jak jsme to prožili",
                child: Column(
                  children: [
                    ReflectionCard(
                      icon: Icons.person,
                      author: l10n.me,
                      text: _myReflection?.text ??
                          l10n.relationshipReflectionPlaceholderMine,
                      editable: true,
                      onTap: () async {
                        final reflection =
                            await Navigator.push<RelationshipReflection>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditRelationshipReflectionScreen(
                              chapterId: widget.chapter.id,
                              authorId: PartnerService.currentUid!,
                            ),
                          ),
                        );

                        if (reflection == null) return;

                        await _reflectionService.saveReflection(reflection);
                        await _loadReflection();
                      },
                    ),
                    ReflectionCard(
                      icon: Icons.favorite,
                      author: l10n.partner,
                      text: _partnerReflection?.text ??
                          l10n.relationshipReflectionPlaceholderPartner,
                      editable: true,
                      onTap: () async {
                        if (_partnerReflection == null) return;

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditRelationshipReflectionScreen(
                              chapterId: widget.chapter.id,
                              authorId: _partnerReflection!.authorId,
                              reflection: _partnerReflection,
                            ),
                          ),
                        );

                        await _loadReflection();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              StorySection(
                icon: Icons.emoji_events_rounded,
                title: "Naše výzva",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chapter.scenario.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.chapter.scenario.description,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.8,
                        color: Colors.brown.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              StorySection(
                icon: Icons.photo_library_rounded,
                title: "Zachycené okamžiky",
                child: Column(
                  children: [
                    if (_photos.isEmpty)
                      Column(
                        children: [
                          Text(
                            "Každá fotografie uchovává okamžik, ke kterému se jednou rádi vrátíte.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.brown.shade700,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            "Tato kapitola zatím čeká na svou první vzpomínku.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () async {
                              final saved = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddRelationshipPhotoScreen(
                                    chapterId: widget.chapter.id,
                                  ),
                                ),
                              );

                              if (saved == true) {
                                await _loadPhotos();
                              }
                            },
                            icon: const Icon(Icons.add_a_photo),
                            label: const Text("Zachytit první okamžik"),
                          ),
                        ],
                      ),
                    if (_photos.isNotEmpty) ...[
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _photos.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final photo = _photos[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RelationshipPhotoViewerScreen(
                                    photos: _photos,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () => _deletePhoto(photo),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Hero(
                                    tag: photo.id,
                                    child: Image.file(
                                      File(photo.storagePath),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      photo.sharedWithPartner
                                          ? Icons.people
                                          : Icons.lock,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                if (PermissionService.canDeletePhoto(photo))
                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: GestureDetector(
                                      onTap: () => _deletePhoto(photo),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.red
                                              .withValues(alpha: 0.85),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final saved = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddRelationshipPhotoScreen(
                                  chapterId: widget.chapter.id,
                                ),
                              ),
                            );

                            if (saved == true) {
                              await _loadPhotos();
                            }
                          },
                          icon: const Icon(Icons.add_a_photo),
                          label: const Text("Přidat další fotografii"),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              StorySection(
                icon: Icons.timeline,
                title: "Náš příběh v čase",
                child: events.isEmpty
                    ? Text(
                        "Zatím nebyly zaznamenány žádné události.",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.brown.shade700,
                        ),
                      )
                    : Column(
                        children: events
                            .map((event) => EventTile(event: event))
                            .toList(),
                      ),
              ),
              const SizedBox(height: 24),
              StorySection(
                icon: Icons.info_outline,
                title: "O této kapitole",
                child: Column(
                  children: [
                    _infoRow(
                      "Stav kapitoly",
                      _statusText(widget.chapter.status),
                    ),
                    const Divider(),
                    _infoRow(
                      "Vytvořeno",
                      _formatDate(widget.chapter.createdAt),
                    ),
                    const Divider(),
                    _infoRow(
                      "Oblíbená kapitola",
                      widget.chapter.favorite? "Ano ❤️" : "Ne",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.brown.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.brown.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _statusText(ChapterStatus status) {
    switch (status) {
      case ChapterStatus.draft:
        return "Koncept";

      case ChapterStatus.waitingForPartner:
        return "Čeká na partnera";

      case ChapterStatus.completed:
        return "Dokončená";

      case ChapterStatus.archived:
        return "Archivovaná";
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}. ${date.month}. ${date.year}";
  }

  Widget _buildLeftBookPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(38, 36, 38, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "KAPITOLA ${widget.chapterNumber}",
            style: TextStyle(
              color: Colors.brown.shade600,
              fontSize: 13,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.chapter.chapterTitle,
            style: TextStyle(
              color: Colors.brown.shade900,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(widget.chapter.createdAt),
            style: TextStyle(
              color: Colors.brown.shade500,
              fontStyle: FontStyle.italic,
              fontSize: 15,
            ),
          ),
          if (_chapterMotto != null) ...[
            const SizedBox(height: 22),
            _buildMottoWhisper(_chapterMotto!),
          ],
          const SizedBox(height: 28),
          if (widget.chapter.introduction.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.chapter.introduction,
                  style: TextStyle(
                    color: Colors.brown.shade900,
                    fontSize: 18,
                    height: 1.8,
                  ),
                ),
              ),
            )
          else
            const Spacer(),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              "— 1 —",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightBookPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(34, 28, 34, 26),
      child: Column(
        children: [
          PhotoFrame(
            image: _photos.isNotEmpty
                ? FileImage(
                    File(_photos.first.storagePath),
                  )
                : null,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddRelationshipPhotoScreen(
                    chapterId: widget.chapter.id,
                  ),
                ),
              );

              if (!mounted) return;

              await _loadPhotos();

              setState(() {});
            },
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                if (_myReflection != null)
                  MemoryBlock(
                    author: "Já",
                    text: _myReflection!.text,
                  ),
                if (_partnerReflection != null) ...[
                  const SizedBox(height: 16),
                  MemoryBlock(
                    author: "Partner",
                    text: _partnerReflection!.text,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              "— 2 —",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}