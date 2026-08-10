import 'package:flutter/material.dart';

import '../theme/book_theme.dart';

class OpenBook extends StatefulWidget {
  final Widget leftPage;
  final Widget rightPage;
  final int leftPageNumber;
  final int rightPageNumber;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const OpenBook({
    super.key,
    required this.leftPage,
    required this.rightPage,
    required this.leftPageNumber,
    required this.rightPageNumber,
    this.onPrevious,
    this.onNext,
  });

  @override
  State<OpenBook> createState() => _OpenBookState();
}

class _OpenBookState extends State<OpenBook> {
  /// Na mobilu:
  ///
  /// 0 = levá stránka
  /// 1 = pravá stránka
  int _mobilePage = 0;

  bool get _isPortrait =>
      MediaQuery.of(context).orientation ==
      Orientation.portrait;

  // ==========================================================
  // MOBILNÍ NAVIGACE
  // ==========================================================

  void _mobileNext() {
    if (!_isPortrait) {
      widget.onNext?.call();
      return;
    }

    // Levá → pravá
    if (_mobilePage == 0) {
      setState(() {
        _mobilePage = 1;
      });
      return;
    }

    // Pravá → další kapitola
    widget.onNext?.call();
  }

  void _mobilePrevious() {
    if (!_isPortrait) {
      widget.onPrevious?.call();
      return;
    }

    // Pravá → levá
    if (_mobilePage == 1) {
      setState(() {
        _mobilePage = 0;
      });
      return;
    }

    // Levá → předchozí kapitola
    widget.onPrevious?.call();
  }

  void _handleSwipe(
    DragEndDetails details,
  ) {
    final velocity =
        details.primaryVelocity ?? 0;

    // Swipe doleva
    if (velocity < -250) {
      _mobileNext();
      return;
    }

    // Swipe doprava
    if (velocity > 250) {
      _mobilePrevious();
    }
  }

  // ==========================================================
  // MOBILNÍ STRÁNKA
  // ==========================================================

  Widget _buildMobilePage() {
    final Widget page =
        _mobilePage == 0
            ? _BookPage(
                pageNumber:
                    widget.leftPageNumber,
                onPageTap:
                    _mobileNext,
                isLeft: true,
                child:
                    widget.leftPage,
              )
            : _BookPage(
                pageNumber:
                    widget.rightPageNumber,
                onPageTap:
                    _mobilePrevious,
                isLeft: false,
                child:
                    widget.rightPage,
              );

    return GestureDetector(
      behavior:
          HitTestBehavior.opaque,
      onHorizontalDragEnd:
          _handleSwipe,
      child: AnimatedSwitcher(
        duration:
            const Duration(
          milliseconds: 300,
        ),
        transitionBuilder:
            (
          child,
          animation,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_mobilePage),
          child: page,
        ),
      ),
    );
  }

  // ==========================================================
  // DESKTOP / TABLET
  // ==========================================================

  Widget _buildOpenBook() {
    return AspectRatio(
      aspectRatio: 1.65,
      child: Container(
        decoration:
            BoxDecoration(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 35,
              spreadRadius: 2,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          child: Row(
            children: [
              Expanded(
                child: _BookPage(
                  pageNumber:
                      widget.leftPageNumber,
                  onPageTap:
                      widget.onPrevious,
                  isLeft: true,
                  child:
                      widget.leftPage,
                ),
              ),

              // ==================================================
              // HŘBET KNIHY
              // ==================================================

              Container(
                width: 26,
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment
                            .centerLeft,
                    end:
                        Alignment
                            .centerRight,
                    colors: [
                      Colors.brown.shade900,
                      Colors.brown.shade700,
                      Colors.brown.shade500,
                      Colors.brown.shade300,
                      Colors.brown.shade500,
                      Colors.brown.shade700,
                      Colors.brown.shade900,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: .25,
                      ),
                      blurRadius: 10,
                      offset:
                          const Offset(
                        -2,
                        0,
                      ),
                    ),
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: .25,
                      ),
                      blurRadius: 10,
                      offset:
                          const Offset(
                        2,
                        0,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _BookPage(
                  pageNumber:
                      widget.rightPageNumber,
                  onPageTap:
                      widget.onNext,
                  isLeft: false,
                  child:
                      widget.rightPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    if (_isPortrait) {
      return Container(
        decoration:
            BoxDecoration(
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 30,
              spreadRadius: 1,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          child: _buildMobilePage(),
        ),
      );
    }

    return _buildOpenBook();
  }
}

// ============================================================
// JEDNA STRÁNKA KNIHY
// ============================================================

class _BookPage extends StatelessWidget {
  final Widget child;
  final bool isLeft;
  final int pageNumber;
  final VoidCallback? onPageTap;

  const _BookPage({
    required this.child,
    required this.isLeft,
    required this.pageNumber,
    this.onPageTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: onPageTap,
      child: Container(
        decoration:
            BoxDecoration(
          color: isLeft
              ? BookTheme.paperLeft
              : BookTheme.paperRight,

          gradient:
              LinearGradient(
            begin: isLeft
                ? Alignment.centerRight
                : Alignment.centerLeft,
            end: isLeft
                ? Alignment.centerLeft
                : Alignment.centerRight,
            colors: isLeft
                ? [
                    const Color(
                      0xFFF4EBDD,
                    ),
                    BookTheme.paperLeft,
                  ]
                : [
                    const Color(
                      0xFFF4EBDD,
                    ),
                    BookTheme.paperRight,
                  ],
          ),

          borderRadius:
              BorderRadius.only(
            topLeft:
                Radius.circular(
              isLeft ? 14 : 3,
            ),
            bottomLeft:
                Radius.circular(
              isLeft ? 14 : 3,
            ),
            topRight:
                Radius.circular(
              isLeft ? 3 : 14,
            ),
            bottomRight:
                Radius.circular(
              isLeft ? 3 : 14,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(
                alpha: .08,
              ),
              blurRadius: 12,
              offset: Offset(
                isLeft ? -2 : 2,
                0,
              ),
            ),
          ],
        ),

        child: Stack(
          children: [
            child,

            IgnorePointer(
              child: Align(
                alignment: isLeft
                    ? Alignment
                        .centerRight
                    : Alignment
                        .centerLeft,
                child: Container(
                  width: 18,
                  decoration:
                      BoxDecoration(
                    gradient:
                        LinearGradient(
                      begin: isLeft
                          ? Alignment
                              .centerRight
                          : Alignment
                              .centerLeft,
                      end: isLeft
                          ? Alignment
                              .centerLeft
                          : Alignment
                              .centerRight,
                      colors: [
                        Colors.black
                            .withValues(
                          alpha: .08,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}