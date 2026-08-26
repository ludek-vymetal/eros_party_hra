import 'package:flutter/material.dart';

import '../book_builder.dart';
import '../models/relationship_chapter.dart';
import '../models/relationship_photo.dart';
import '../models/relationship_reflection.dart';

import '../repositories/relationship_book_repository.dart';
import '../services/relationship_chapter_service.dart';
import '../widgets/chapter_options_sheet.dart';

class BookViewerRefreshData {
  final List<RelationshipChapter> chapters;

  final Map<String, List<RelationshipPhoto>>
      photosByChapter;

  final Map<String, RelationshipReflection?>
      myReflectionsByChapter;

  final Map<String, RelationshipReflection?>
      partnerReflectionsByChapter;

  const BookViewerRefreshData({
    required this.chapters,
    required this.photosByChapter,
    required this.myReflectionsByChapter,
    required this.partnerReflectionsByChapter,
  });
}

class RelationshipBookViewerScreen
    extends StatefulWidget {
  final List<Widget> spreads;
  final List<RelationshipChapter> chapters;
  final RelationshipBookRepository repository;
  final int initialIndex;
  final PageController pageController;

  final Future<BookViewerRefreshData>
      Function() onRefreshBook;

  final Future<void> Function(
    String chapterId,
  ) onAddPhoto;

  final Future<void> Function(
    String chapterId,
  ) onAddReflection;

  const RelationshipBookViewerScreen({
    super.key,
    required this.spreads,
    required this.chapters,
    required this.repository,
    required this.initialIndex,
    required this.pageController,
    required this.onRefreshBook,
    required this.onAddPhoto,
    required this.onAddReflection,
  });

  @override
  State<RelationshipBookViewerScreen>
      createState() =>
          _RelationshipBookViewerScreenState();
}

class _RelationshipBookViewerScreenState
    extends State<RelationshipBookViewerScreen> {
  late int currentSpread;

  late List<RelationshipChapter>
      _chapters;

  late List<Widget> _spreads;

  final RelationshipChapterService
      _chapterService =
      RelationshipChapterService();

  

  @override
  void initState() {
    super.initState();

    _chapters =
        List<RelationshipChapter>.from(
      widget.chapters,
    );

    _spreads =
        List<Widget>.from(
      widget.spreads,
    );

    currentSpread =
        widget.initialIndex.clamp(
      0,
      _spreads.length - 1,
    );

    

    widget.pageController
        .addListener(
      _onPageChanged,
    );
  }

  @override
  void dispose() {
    widget.pageController
        .removeListener(
      _onPageChanged,
    );

    super.dispose();
  }

  // ==========================================================
  // PAGE CHANGE
  // ==========================================================

  void _onPageChanged() {
    final page =
        widget.pageController.page;

    if (page == null) {
      return;
    }

    final index = page.round();

    if (index != currentSpread &&
        index >= 0 &&
        index < _spreads.length) {
      setState(() {
        currentSpread = index;
      });
    }
  }

  // ==========================================================
  // REBUILD KNIHY
  // ==========================================================

  Future<void> _refreshBook() async {
    final data =
        await widget.onRefreshBook();

    if (!mounted) {
      return;
    }

    final newSpreads =
        BookBuilder.build(
      chapters:
          data.chapters,

      photosByChapter:
          data.photosByChapter,

      myReflectionsByChapter:
          data.myReflectionsByChapter,

      partnerReflectionsByChapter:
          data.partnerReflectionsByChapter,

      pageController:
          widget.pageController,

      onAddPhoto:
          widget.onAddPhoto,

      onAddReflection:
          widget.onAddReflection,
    );

    final newIndex =
        currentSpread.clamp(
      0,
      newSpreads.length - 1,
    );

    setState(() {
      _chapters =
          List<RelationshipChapter>.from(
        data.chapters,
      );

      _spreads =
          newSpreads;

      currentSpread =
          newIndex;
    });

    // --------------------------------------------------------
    // Po překreslení zajistíme, aby PageView zůstala
    // na stejné kapitole.
    // --------------------------------------------------------

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        if (widget.pageController
            .hasClients) {
          widget.pageController.jumpToPage(
            currentSpread,
          );
        }
      },
    );
  }

  // ==========================================================
  // NAVIGACE
  // ==========================================================

  void nextSpread() {
    if (currentSpread >=
        _spreads.length - 1) {
      return;
    }

    widget.pageController.nextPage(
      duration:
          const Duration(
        milliseconds: 400,
      ),
      curve:
          Curves.easeInOut,
    );
  }

  void previousSpread() {
    if (currentSpread <= 0) {
      return;
    }

    widget.pageController.previousPage(
      duration:
          const Duration(
        milliseconds: 400,
      ),
      curve:
          Curves.easeInOut,
    );
  }

  
  

  // ==========================================================
  // POZNÁMKA
  // ==========================================================

  

  // ==========================================================
  // MENU KAPITOLY
  // ==========================================================

  Future<void>
      _handleOptionsSheet() async {
    if (currentSpread >=
        _chapters.length) {
      return;
    }

    final currentChapter =
        _chapters[currentSpread];

    final result =
        await ChapterOptionsSheet.show(
      context,
      chapter:
          currentChapter,
      repository:
          widget.repository,
    );

    if (result == null ||
        !mounted) {
      return;
    }

    switch (result) {
      // ------------------------------------------------------
      // OBLÍBENÁ
      // ------------------------------------------------------

      case ChapterOptionResult
          .favoriteToggled:
        await _chapterService
            .toggleFavorite(
          currentChapter,
        );

        if (!mounted) {
          return;
        }

        await _refreshBook();
        break;

      // ------------------------------------------------------
      // MOTTO
      // ------------------------------------------------------

      case ChapterOptionResult
          .mottoUpdated:
        await _refreshBook();
        break;

      // ------------------------------------------------------
      // ARCHIVACE
      // ------------------------------------------------------

      case ChapterOptionResult
          .archived:
        await _chapterService
            .archiveChapter(
          currentChapter,
        );

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Kapitola byla archivována.',
            ),
          ),
        );

        await _refreshBook();
        break;

      // ------------------------------------------------------
      // SMAZÁNÍ
      // ------------------------------------------------------

      case ChapterOptionResult
          .deleted:
        await _chapterService
            .deleteChapter(
          currentChapter.id,
        );

        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Kapitola byla přesunuta do koše.',
            ),
          ),
        );

        await _refreshBook();
        break;
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_spreads.isEmpty ||
        _chapters.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Kniha zatím nemá žádné kapitoly.',
          ),
        ),
      );
    }

    final safeIndex =
        currentSpread.clamp(
      0,
      _spreads.length - 1,
    );

    final currentChapter =
        _chapters[
          safeIndex.clamp(
            0,
            _chapters.length - 1,
          )
        ];

    return Scaffold(
      backgroundColor:
          const Color(0xFFD9C3A0),

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor:
            const Color(0xFFD9C3A0),
        elevation: 0,
        centerTitle: true,

        title: Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            if (currentChapter.favorite) ...[
              const Icon(
                Icons.favorite,
                color:
                    Color(0xFFC84B31),
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
            ],

            Flexible(
              child: Text(
                currentChapter
                    .chapterTitle,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark_border,
              color:
                  Color(0xFF5A342B),
              size: 25,
            ),
            tooltip:
                'Možnosti kapitoly',
            onPressed:
                _handleOptionsSheet,
          ),
        ],
      ),

      // ======================================================
      // KNIHA
      // ======================================================

      body: SafeArea(
        child:
            LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final isPortrait =
                constraints.maxHeight >
                    constraints.maxWidth;

            final bookWidth =
                isPortrait
                    ? constraints.maxWidth *
                        0.96
                    : constraints.maxWidth *
                        0.88;

            return Center(
              child: SizedBox(
                width:
                    bookWidth,
                child:
                    PageView.builder(
                  controller:
                      widget.pageController,

                  itemCount:
                      _spreads.length,

                  physics:
                      const BouncingScrollPhysics(),

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    return _spreads[index];
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

      bottomNavigationBar:
          SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(
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
                onPressed:
                    currentSpread > 0
                        ? previousSpread
                        : null,
                icon:
                    const Icon(
                  Icons.chevron_left,
                ),
                iconSize: 32,
                tooltip:
                    'Předchozí kapitola',
              ),

              const SizedBox(
                width: 20,
              ),

              Text(
                '${currentSpread + 1} / ${_spreads.length}',
                style:
                    const TextStyle(
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const SizedBox(
                width: 20,
              ),

              IconButton(
                onPressed:
                    currentSpread <
                            _spreads.length -
                                1
                        ? nextSpread
                        : null,
                icon:
                    const Icon(
                  Icons.chevron_right,
                ),
                iconSize: 32,
                tooltip:
                    'Další kapitola',
              ),
            ],
          ),
        ),
      ),
    );
  }
}