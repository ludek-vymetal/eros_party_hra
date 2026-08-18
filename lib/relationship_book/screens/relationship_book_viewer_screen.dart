import 'package:flutter/material.dart';

import '../engine/chapter_engine.dart';
import '../models/relationship_chapter.dart';
import '../repositories/relationship_book_repository.dart';
import '../services/relationship_chapter_service.dart';
import '../widgets/chapter_options_sheet.dart';

class RelationshipBookViewerScreen extends StatefulWidget {
  final List<Widget> spreads;
  final List<RelationshipChapter> chapters;
  final RelationshipBookRepository repository;
  final int initialIndex;
  final PageController pageController;

  const RelationshipBookViewerScreen({
    super.key,
    required this.spreads,
    required this.chapters,
    required this.repository,
    required this.initialIndex,
    required this.pageController,
  });

  @override
  State<RelationshipBookViewerScreen> createState() =>
      _RelationshipBookViewerScreenState();
}

class _RelationshipBookViewerScreenState
    extends State<RelationshipBookViewerScreen> {
  late int currentSpread;

  final RelationshipChapterService _chapterService =
      RelationshipChapterService();

  late final ChapterEngine _chapterEngine;

  @override
  void initState() {
    super.initState();

    currentSpread = widget.initialIndex.clamp(
      0,
      widget.spreads.length - 1,
    );

    _chapterEngine = ChapterEngine(
      repository: widget.repository,
    );

    widget.pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    final page = widget.pageController.page;

    if (page == null) {
      return;
    }

    final index = page.round();

    if (index != currentSpread &&
        index >= 0 &&
        index < widget.spreads.length) {
      setState(() {
        currentSpread = index;
      });
    }
  }

  // ==========================================================
  // NAVIGACE
  // ==========================================================

  void nextSpread() {
    if (currentSpread >= widget.spreads.length - 1) {
      return;
    }

    widget.pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void previousSpread() {
    if (currentSpread <= 0) {
      return;
    }

    widget.pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // ==========================================================
  // MENU KAPITOLY
  // ==========================================================

  Future<void> _handleOptionsSheet() async {
    if (currentSpread >= widget.chapters.length) {
      return;
    }

    final currentChapter =
        widget.chapters[currentSpread];

    final result = await ChapterOptionsSheet.show(
      context,
      chapter: currentChapter,
      repository: widget.repository,
    );

    if (result == null || !mounted) {
      return;
    }

    switch (result) {
      case ChapterOptionResult.favoriteToggled:
        await _chapterService.toggleFavorite(
          currentChapter,
        );

        if (!mounted) {
          return;
        }

        setState(() {
          widget.chapters[currentSpread] =
              currentChapter.copyWith(
            favorite: !currentChapter.favorite,
          );
        });

        break;

      case ChapterOptionResult.mottoUpdated:
        final updated =
            await _chapterEngine.getChapter(
          currentChapter.id,
        );

        if (updated != null && mounted) {
          setState(() {
            widget.chapters[currentSpread] = updated;
          });
        }

        break;

      case ChapterOptionResult.archived:
        await _chapterService.archiveChapter(
          currentChapter,
        );

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Kapitola byla archivována.',
            ),
          ),
        );

        break;

      case ChapterOptionResult.deleted:
        await _chapterService.deleteChapter(
          currentChapter.id,
        );

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Kapitola byla přesunuta do koše.',
            ),
          ),
        );

        break;
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    if (widget.spreads.isEmpty ||
        widget.chapters.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Kniha zatím nemá žádné kapitoly.',
          ),
        ),
      );
    }

    final safeIndex = currentSpread.clamp(
      0,
      widget.spreads.length - 1,
    );

    final currentChapter =
        widget.chapters[
            safeIndex.clamp(
              0,
              widget.chapters.length - 1,
            )];

    return Scaffold(
      backgroundColor: const Color(0xFFD9C3A0),

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFFD9C3A0),
        elevation: 0,
        centerTitle: true,

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentChapter.favorite) ...[
              const Icon(
                Icons.favorite,
                color: Color(0xFFC84B31),
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                currentChapter.chapterTitle,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              size: 28,
            ),
            tooltip: 'Možnosti kapitoly',
            onPressed: _handleOptionsSheet,
          ),
        ],
      ),

      // ======================================================
      // JEDNA STRÁNKA KNIHY
      // ======================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final isPortrait =
                constraints.maxHeight >
                    constraints.maxWidth;

            final bookWidth = isPortrait
                ? constraints.maxWidth * 0.96
                : constraints.maxWidth * 0.88;

            return Center(
              child: SizedBox(
                width: bookWidth,
                child: PageView.builder(
                  controller: widget.pageController,
                  itemCount: widget.spreads.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return widget.spreads[index];
                  },
                ),
              ),
            );
          },
        ),
      ),

      // ======================================================
      // NAVIGACE
      // ======================================================

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 8,
            top: 4,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: currentSpread > 0
                    ? previousSpread
                    : null,
                icon: const Icon(
                  Icons.chevron_left,
                ),
                iconSize: 32,
                tooltip: 'Předchozí kapitola',
              ),

              const SizedBox(width: 20),

              Text(
                '${currentSpread + 1} / ${widget.spreads.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 20),

              IconButton(
                onPressed:
                    currentSpread <
                            widget.spreads.length - 1
                        ? nextSpread
                        : null,
                icon: const Icon(
                  Icons.chevron_right,
                ),
                iconSize: 32,
                tooltip: 'Další kapitola',
              ),
            ],
          ),
        ),
      ),
    );
  }
}