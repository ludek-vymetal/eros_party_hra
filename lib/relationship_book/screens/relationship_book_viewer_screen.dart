import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../services/cloud_partner_service.dart';

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

  /// Pouze kapitoly vytvořené BookBuilderem.
  late List<Widget> _chapterSpreads;

  /// Celá kniha:
  /// index 0 = OBÁLKA
  /// index 1+ = kapitoly
  late List<Widget> _bookPages;

  final RelationshipChapterService
      _chapterService =
      RelationshipChapterService();

  String _myName = 'Já';

  String _partnerName = 'Partner';

  bool _namesLoaded = false;

  bool get _isCover =>
      currentSpread == 0;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    _chapters =
        List<RelationshipChapter>.from(
      widget.chapters,
    );

    _chapterSpreads =
        List<Widget>.from(
      widget.spreads,
    );

    // Vytvoříme knihu:
    // OBÁLKA + všechny kapitoly.
    _rebuildBookPages();

    // Začínáme na obálce.
    currentSpread = 0;

    widget.pageController.addListener(
      _onPageChanged,
    );

    _loadNames();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(
      _onPageChanged,
    );

    super.dispose();
  }

  // ==========================================================
  // JMÉNA
  // ==========================================================

  Future<void> _loadNames() async {
    try {
      // ------------------------------------------------------
      // MOJE JMÉNO
      // ------------------------------------------------------

      final myName =
          await CloudPartnerService
              .getMyDisplayName();

      // ------------------------------------------------------
      // PARTNER
      // ------------------------------------------------------

      final partnerUid =
          await CloudPartnerService
              .getPartnerUid();

      String? partnerName;

      if (partnerUid != null &&
          partnerUid.isNotEmpty) {
        partnerName =
            await CloudPartnerService
                .getUserDisplayName(
          partnerUid,
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        if (myName != null &&
            myName.trim().isNotEmpty) {
          _myName = myName.trim();
        }

        if (partnerName != null &&
            partnerName.trim().isNotEmpty) {
          _partnerName =
              partnerName.trim();
        }

        _namesLoaded = true;

        _rebuildBookPages();
      });
    } catch (e) {
      debugPrint(
        'CHYBA PRI NAČÍTÁNÍ JMEN: $e',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _namesLoaded = true;

        _rebuildBookPages();
      });
    }
  }

  // ==========================================================
  // VYTVOŘENÍ CELÉ KNIHY
  // ==========================================================

  void _rebuildBookPages() {
    _bookPages = [
      _RelationshipBookCover(
        myName: _myName,
        partnerName: _partnerName,
        namesLoaded: _namesLoaded,
      ),

      ..._chapterSpreads,
    ];
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

    final index =
        page.round();

    if (index != currentSpread &&
        index >= 0 &&
        index < _bookPages.length) {
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

    final newChapterSpreads =
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
      newChapterSpreads.length,
    );

    setState(() {
      _chapters =
          List<RelationshipChapter>.from(
        data.chapters,
      );

      _chapterSpreads =
          newChapterSpreads;

      _rebuildBookPages();

      currentSpread =
          newIndex;
    });

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
        _bookPages.length - 1) {
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
  // MENU KAPITOLY
  // ==========================================================

  Future<void>
      _handleOptionsSheet() async {
    // Na obálce není menu kapitoly.
    if (_isCover) {
      return;
    }

    // Protože index 0 je obálka,
    // kapitoly začínají od indexu 1.
    final chapterIndex =
        currentSpread - 1;

    if (chapterIndex < 0 ||
        chapterIndex >=
            _chapters.length) {
      return;
    }

    final currentChapter =
        _chapters[chapterIndex];

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

      case ChapterOptionResult
          .mottoUpdated:
        await _refreshBook();

        break;

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
    if (_bookPages.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    RelationshipChapter?
        currentChapter;

    if (!_isCover &&
        _chapters.isNotEmpty) {
      final chapterIndex =
          (currentSpread - 1).clamp(
        0,
        _chapters.length - 1,
      );

      currentChapter =
          _chapters[chapterIndex];
    }

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

        title: _isCover

            // ------------------------------------------------
            // OBÁLKA
            // ------------------------------------------------

            ? const Text(
                'Naše vzpomínky',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              )

            // ------------------------------------------------
            // KAPITOLA
            // ------------------------------------------------

            : Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  if (currentChapter
                          ?.favorite ==
                      true) ...[
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
                              ?.chapterTitle ??
                          'Kapitola',
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
          if (!_isCover)
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
                      _bookPages.length,

                  physics:
                      const BouncingScrollPhysics(),

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    return _bookPages[index];
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
                    'Předchozí stránka',
              ),

              const SizedBox(
                width: 20,
              ),

              Text(
                '${currentSpread + 1} / ${_bookPages.length}',
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
                            _bookPages.length -
                                1
                        ? nextSpread
                        : null,

                icon:
                    const Icon(
                  Icons.chevron_right,
                ),

                iconSize: 32,

                tooltip:
                    'Další stránka',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// STARÁ KOŽENÁ OBÁLKA KNIHY
// ============================================================

class _RelationshipBookCover extends StatelessWidget {
  final String myName;
  final String partnerName;
  final bool namesLoaded;

  const _RelationshipBookCover({
    required this.myName,
    required this.partnerName,
    required this.namesLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait =
            constraints.maxHeight > constraints.maxWidth;

        // ======================================================
        // ROZMĚRY OBÁLKY
        // ======================================================

        final double maxHeight =
            constraints.maxHeight * 0.92;

        final double maxWidth =
            constraints.maxWidth * 0.88;

        // Poměr obálky – tento už neměníme.
        final double bookHeight =
            isPortrait
                ? constraints.maxHeight * 0.90
                : maxHeight;

        final double bookWidth =
            math.min(
              bookHeight * 0.77,
              maxWidth,
            );

        return Center(
          child: SizedBox(
            width: bookWidth,
            height: bookHeight,

            child: Stack(
              clipBehavior: Clip.none,
              children: [

                // ==================================================
                // TEXTURA STARÉ KŮŽE
                // ==================================================

                Positioned.fill(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(16),

                    child: Image.asset(
                      'assets/images/book_cover_texture.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ==================================================
                // JEMNÉ ZATMAVENÍ
                // ==================================================

                Positioned.fill(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(16),

                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin:
                              Alignment.topLeft,
                          end:
                              Alignment.bottomRight,

                          colors: [
                            Colors.black.withValues(
                              alpha: 0.08,
                            ),

                            Colors.transparent,

                            Colors.black.withValues(
                              alpha: 0.36,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // VNĚJŠÍ KOŽENÝ OKRAJ
                // ==================================================

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(16),

                      border: Border.all(
                        color:
                            const Color(0xFF9E7A42),
                        width: 2,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withValues(
                            alpha: 0.60,
                          ),

                          blurRadius: 28,
                          spreadRadius: 2,

                          offset:
                              const Offset(
                            0,
                            16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // VNITŘNÍ ZLATÝ RÁMEČEK
                // ==================================================

                Positioned(
                  left:
                      bookWidth * 0.08,

                  right:
                      bookWidth * 0.08,

                  top:
                      bookHeight * 0.075,

                  bottom:
                      bookHeight * 0.075,

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8),

                      border: Border.all(
                        color:
                            const Color(0xFFB99555),

                        width: 1.2,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // VNITŘNÍ OBSAH
                //
                // DŮLEŽITÉ:
                //
                // Nepoužíváme zde Column s výškou obálky.
                // Máme pevnou "návrhovou" velikost a FittedBox
                // ji celou přizpůsobí dostupnému prostoru.
                //
                // Díky tomu nemůže vzniknout RenderFlex overflow.
                // ==================================================

                Positioned(
                  left:
                      bookWidth * 0.13,

                  right:
                      bookWidth * 0.13,

                  top:
                      bookHeight * 0.085,

                  bottom:
                      bookHeight * 0.085,

                  child: FittedBox(
                    fit: BoxFit.contain,

                    alignment:
                        Alignment.center,

                    child: SizedBox(
                      width: 360,
                      height: 620,

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        crossAxisAlignment:
                            CrossAxisAlignment.center,

                        children: [

                          // ========================================
                          // IKONA KNIHY
                          // ========================================

                          const Icon(
                            Icons.auto_stories,
                            color:
                                Color(0xFFE5C77F),
                            size: 58,
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          // ========================================
                          // NAŠE
                          // ========================================

                          const Text(
                            'N A Š E',
                            textAlign:
                                TextAlign.center,

                            style: TextStyle(
                              color:
                                  Color(0xFFE5C77F),

                              fontSize: 19,

                              letterSpacing: 7,

                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // ========================================
                          // VZPOMÍNKY
                          // ========================================

                          const FittedBox(
                            fit:
                                BoxFit.scaleDown,

                            child: Text(
                              'VZPOMÍNKY',

                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFFFFF1D2,
                                ),

                                fontSize: 43,

                                fontWeight:
                                    FontWeight.bold,

                                letterSpacing: 2,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          // ========================================
                          // ZLATÁ LINKA
                          // ========================================

                          Container(
                            width: 205,
                            height: 1.5,

                            decoration:
                                const BoxDecoration(
                              color:
                                  Color(
                                0xFFC9A45F,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 27,
                          ),

                          // ========================================
                          // JMÉNA
                          // ========================================

                          if (!namesLoaded)

                            const SizedBox(
                              width: 30,
                              height: 30,

                              child:
                                  CircularProgressIndicator(
                                color:
                                    Color(
                                  0xFFE5C77F,
                                ),
                                strokeWidth: 2,
                              ),
                            )

                          else ...[

                            // ------------------------------------
                            // MOJE JMÉNO
                            // ------------------------------------

                            FittedBox(
                              fit:
                                  BoxFit.scaleDown,

                              child: Text(
                                myName,

                                textAlign:
                                    TextAlign.center,

                                style:
                                    const TextStyle(
                                  color:
                                      Color(
                                    0xFFFFF1D2,
                                  ),

                                  fontSize: 31,

                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // ------------------------------------
                            // SRDCE
                            // ------------------------------------

                            const Icon(
                              Icons.favorite,

                              color:
                                  Color(
                                0xFFC84B31,
                              ),

                              size: 30,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // ------------------------------------
                            // PARTNER
                            // ------------------------------------

                            FittedBox(
                              fit:
                                  BoxFit.scaleDown,

                              child: Text(
                                partnerName,

                                textAlign:
                                    TextAlign.center,

                                style:
                                    const TextStyle(
                                  color:
                                      Color(
                                    0xFFFFF1D2,
                                  ),

                                  fontSize: 31,

                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(
                            height: 27,
                          ),

                          // ========================================
                          // PODTITULEK
                          // ========================================

                          FittedBox(
                            fit:
                                BoxFit.scaleDown,

                            child: const Text(
                              'Příběh, který píšeme spolu',

                              textAlign:
                                  TextAlign.center,

                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFFE0C89F,
                                ),

                                fontSize: 15,

                                fontStyle:
                                    FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}