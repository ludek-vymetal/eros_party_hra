import 'dart:math' as math;

import 'package:flutter/material.dart';

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

class _OpenBookState extends State<OpenBook>
    with SingleTickerProviderStateMixin {
  // ==========================================================
  // MOBIL
  // ==========================================================

  /// 0 = levá stránka
  /// 1 = pravá stránka
  int _mobilePage = 0;

  late final AnimationController _flipController;

  bool _isAnimating = false;

  /// true = listujeme dopředu
  /// false = listujeme zpět
  bool _forward = true;

  bool get _isPortrait =>
      MediaQuery.of(context).orientation ==
      Orientation.portrait;

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 550,
      ),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  // ==========================================================
  // MOBILNÍ LISTOVÁNÍ
  // ==========================================================

  Future<void> _flipToPage(
    int targetPage, {
    required bool forward,
  }) async {
    if (_isAnimating ||
        targetPage == _mobilePage) {
      return;
    }

    _isAnimating = true;
    _forward = forward;

    if (mounted) {
      setState(() {});
    }

    await _flipController.forward(
      from: 0,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _mobilePage = targetPage;
    });

    _flipController.reset();

    _isAnimating = false;
  }

  Future<void> _mobileNext() async {
    if (_isAnimating) {
      return;
    }

    if (!_isPortrait) {
      widget.onNext?.call();
      return;
    }

    // --------------------------------------------------------
    // Levá stránka → pravá stránka
    // --------------------------------------------------------

    if (_mobilePage == 0) {
      await _flipToPage(
        1,
        forward: true,
      );

      return;
    }

    // --------------------------------------------------------
    // Pravá stránka → další kapitola
    // --------------------------------------------------------

    widget.onNext?.call();
  }

  Future<void> _mobilePrevious() async {
    if (_isAnimating) {
      return;
    }

    if (!_isPortrait) {
      widget.onPrevious?.call();
      return;
    }

    // --------------------------------------------------------
    // Pravá stránka → levá stránka
    // --------------------------------------------------------

    if (_mobilePage == 1) {
      await _flipToPage(
        0,
        forward: false,
      );

      return;
    }

    // --------------------------------------------------------
    // Levá stránka → předchozí kapitola
    // --------------------------------------------------------

    widget.onPrevious?.call();
  }

  void _handleSwipe(
    DragEndDetails details,
  ) {
    final velocity =
        details.primaryVelocity ?? 0;

    if (velocity < -250) {
      _mobileNext();
      return;
    }

    if (velocity > 250) {
      _mobilePrevious();
    }
  }

  // ==========================================================
  // MOBILNÍ OBSAH STRÁNKY
  // ==========================================================

  Widget _buildMobilePageContent() {
    if (_mobilePage == 0) {
      return _BookPage(
        key: const ValueKey(
          'left_page',
        ),
        pageNumber:
            widget.leftPageNumber,
        onPageTap:
            _mobileNext,
        isLeft: true,
        child:
            widget.leftPage,
      );
    }

    return _BookPage(
      key: const ValueKey(
        'right_page',
      ),
      pageNumber:
          widget.rightPageNumber,
      onPageTap:
          _mobilePrevious,
      isLeft: false,
      child:
          widget.rightPage,
    );
  }

  // ==========================================================
  // MOBILNÍ KNIHA
  // ==========================================================

  Widget _buildMobileBook() {
    return GestureDetector(
      behavior:
          HitTestBehavior.opaque,

      onHorizontalDragEnd:
          _handleSwipe,

      child: AnimatedBuilder(
        animation:
            _flipController,

        builder:
            (context, child) {
          final value =
              _flipController.value;

          if (!_isAnimating ||
              value == 0) {
            return _buildMobilePageContent();
          }

          final angle =
              _forward
                  ? value *
                      math.pi *
                      0.42
                  : -value *
                      math.pi *
                      0.42;

          final alignment =
              _forward
                  ? Alignment.centerLeft
                  : Alignment.centerRight;

          final shadowOpacity =
              math.sin(
                    value *
                        math.pi,
                  ) *
                  0.28;

          return Stack(
            fit:
                StackFit.expand,

            children: [

              _buildMobilePageContent(),

              Transform(
                alignment:
                    alignment,

                transform:
                    Matrix4.identity()
                      ..setEntry(
                        3,
                        2,
                        0.0015,
                      )
                      ..rotateY(
                        angle,
                      ),

                child: Opacity(
                  opacity:
                      1 -
                      value *
                          0.15,

                  child:
                      _buildMobilePageContent(),
                ),
              ),

              IgnorePointer(
                child: Container(
                  decoration:
                      BoxDecoration(
                    gradient:
                        LinearGradient(
                      begin:
                          _forward
                              ? Alignment.centerLeft
                              : Alignment.centerRight,

                      end:
                          _forward
                              ? Alignment.centerRight
                              : Alignment.centerLeft,

                      colors: [
                        Colors.black
                            .withValues(
                          alpha:
                              shadowOpacity,
                        ),

                        Colors.transparent,

                        Colors.black
                            .withValues(
                          alpha:
                              shadowOpacity *
                                  0.35,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // OTEVŘENÁ KNIHA – PC / TABLET
  //
  // DŮLEŽITÉ:
  //
  // Jedna stránka má poměr přibližně:
  //
  //       0.66 : 1
  //
  // což odpovídá obálce.
  //
  // Proto otevřená kniha není nastavena přes klasický
  // AspectRatio celého widgetu.
  // ==========================================================

  Widget _buildOpenBook() {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        // ------------------------------------------------------
        // POMĚR JEDNÉ STRÁNKY
        //
        // Stejný jako obálka.
        // ------------------------------------------------------

        const double pageRatio =
            0.66;

        // ------------------------------------------------------
        // HŘBET
        // ------------------------------------------------------

        const double spineWidth =
            28.0;

        // ------------------------------------------------------
        // KNIHA NEZABERE ÚPLNĚ CELOU PLOCHU
        // ------------------------------------------------------

        final double availableWidth =
            constraints.maxWidth *
                0.94;

        final double availableHeight =
            constraints.maxHeight *
                0.90;

        // ------------------------------------------------------
        // VÝŠKA URČENÁ ŠÍŘKOU
        //
        // 2 × stránka + hřbet
        // ------------------------------------------------------

        final double heightFromWidth =
            (availableWidth -
                    spineWidth) /
                (pageRatio * 2);

        // ------------------------------------------------------
        // VYBEREME MENŠÍ ROZMĚR
        //
        // Díky tomu se kniha nikdy neroztáhne mimo prostor.
        // ------------------------------------------------------

        final double bookHeight =
            math.min(
              availableHeight,
              heightFromWidth,
            );

        // ------------------------------------------------------
        // ŠÍŘKA JEDNÉ STRÁNKY
        // ------------------------------------------------------

        final double pageWidth =
            bookHeight *
                pageRatio;

        // ------------------------------------------------------
        // CELÁ KNIHA
        // ------------------------------------------------------

        final double bookWidth =
            pageWidth * 2 +
                spineWidth;

        return Center(
          child: SizedBox(
            width:
                bookWidth,

            height:
                bookHeight,

            child: Container(
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),

                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(
                      alpha: 0.34,
                    ),

                    blurRadius: 36,

                    spreadRadius: 2,

                    offset:
                        const Offset(
                      0,
                      18,
                    ),
                  ),
                ],
              ),

              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),

                child: Row(
                  children: [

                    // ==================================================
                    // LEVÁ STRÁNKA
                    // ==================================================

                    SizedBox(
                      width:
                          pageWidth,

                      child: _BookPage(
                        pageNumber:
                            widget.leftPageNumber,

                        onPageTap:
                            widget.onPrevious,

                        isLeft:
                            true,

                        child:
                            widget.leftPage,
                      ),
                    ),

                    // ==================================================
                    // HŘBET
                    // ==================================================

                    const _LeatherSpine(),

                    // ==================================================
                    // PRAVÁ STRÁNKA
                    // ==================================================

                    SizedBox(
                      width:
                          pageWidth,

                      child: _BookPage(
                        pageNumber:
                            widget.rightPageNumber,

                        onPageTap:
                            widget.onNext,

                        isLeft:
                            false,

                        child:
                            widget.rightPage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    // --------------------------------------------------------
    // MOBIL
    // --------------------------------------------------------

    if (_isPortrait) {
      return Container(
        decoration:
            BoxDecoration(
          borderRadius:
              BorderRadius.circular(
            18,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.28,
              ),

              blurRadius: 30,

              spreadRadius: 1,

              offset:
                  const Offset(
                0,
                12,
              ),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(
            18,
          ),

          child:
              _buildMobileBook(),
        ),
      );
    }

    // --------------------------------------------------------
    // PC / TABLET
    // --------------------------------------------------------

    return _buildOpenBook();
  }
}

// ============================================================
// HŘBET KNIHY
// STARÁ TMAVÁ KŮŽE
// ============================================================

class _LeatherSpine
    extends StatelessWidget {
  const _LeatherSpine();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 28,

      decoration:
          BoxDecoration(
        // ==================================================
        // TMAVÁ KŮŽE
        // ==================================================

        gradient:
            const LinearGradient(
          begin:
              Alignment.centerLeft,

          end:
              Alignment.centerRight,

          colors: [
            Color(0xFF120705),
            Color(0xFF24100C),
            Color(0xFF47231A),
            Color(0xFF5A2D21),
            Color(0xFF47231A),
            Color(0xFF24100C),
            Color(0xFF120705),
          ],

          stops: [
            0.00,
            0.14,
            0.30,
            0.50,
            0.70,
            0.86,
            1.00,
          ],
        ),

        // ==================================================
        // OKRAJE HŘBETU
        // ==================================================

        border:
            const Border.symmetric(
          vertical:
              BorderSide(
            color:
                Color(0xFF70472A),

            width: 0.8,
          ),
        ),

        // ==================================================
        // STÍN DO STRÁNEK
        // ==================================================

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.48,
            ),

            blurRadius: 13,

            spreadRadius: 1,

            offset:
                const Offset(
              -4,
              0,
            ),
          ),

          BoxShadow(
            color:
                Colors.black.withValues(
              alpha: 0.48,
            ),

            blurRadius: 13,

            spreadRadius: 1,

            offset:
                const Offset(
              4,
              0,
            ),
          ),
        ],
      ),

      child: Stack(
        children: [

          // ==================================================
          // STARÁ KŮŽE – PRASKLINY
          // ==================================================

          Positioned.fill(
            child: CustomPaint(
              painter:
                  _SpineAgingPainter(),
            ),
          ),

          // ==================================================
          // JEMNÝ STŘEDOVÝ ODLESK
          // ==================================================

          Center(
            child: Container(
              width: 3,

              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topCenter,

                  end:
                      Alignment.bottomCenter,

                  colors: [
                    Colors.transparent,

                    const Color(
                      0xFFB47B4B,
                    ).withValues(
                      alpha: 0.20,
                    ),

                    const Color(
                      0xFF7A4D30,
                    ).withValues(
                      alpha: 0.12,
                    ),

                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STÁRNUTÍ HŘBETU
// ============================================================

class _SpineAgingPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final crackPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              0.7
          ..strokeCap =
              StrokeCap.round;

    final cracks = [
      [
        0.28,
        0.00,
        0.23,
        0.18,
      ],
      [
        0.23,
        0.18,
        0.30,
        0.36,
      ],
      [
        0.72,
        0.05,
        0.67,
        0.24,
      ],
      [
        0.67,
        0.24,
        0.74,
        0.42,
      ],
      [
        0.34,
        0.62,
        0.28,
        0.84,
      ],
      [
        0.66,
        0.58,
        0.72,
        0.88,
      ],
    ];

    for (final crack
        in cracks) {
      final path = Path();

      path.moveTo(
        size.width *
            crack[0],
        size.height *
            crack[1],
      );

      path.lineTo(
        size.width *
            crack[2],
        size.height *
            crack[3],
      );

      crackPaint.color =
          const Color(
        0xFFB07A4B,
      ).withValues(
        alpha: 0.18,
      );

      canvas.drawPath(
        path,
        crackPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ============================================================
// JEDNA STRÁNKA
// STARÝ POPRASKANÝ PERGAMEN
// ============================================================

class _BookPage
    extends StatelessWidget {
  final Widget child;

  final bool isLeft;

  final int pageNumber;

  final VoidCallback? onPageTap;

  const _BookPage({
    super.key,
    required this.child,
    required this.isLeft,
    required this.pageNumber,
    this.onPageTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final borderRadius =
        BorderRadius.only(
      topLeft:
          Radius.circular(
        isLeft ? 14 : 4,
      ),

      bottomLeft:
          Radius.circular(
        isLeft ? 14 : 4,
      ),

      topRight:
          Radius.circular(
        isLeft ? 4 : 14,
      ),

      bottomRight:
          Radius.circular(
        isLeft ? 4 : 14,
      ),
    );

    return GestureDetector(
      onTap:
          onPageTap,

      child: Container(
        decoration:
            BoxDecoration(
          borderRadius:
              borderRadius,

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.12,
              ),

              blurRadius: 16,

              offset:
                  Offset(
                isLeft ? -2 : 2,
                1,
              ),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius:
              borderRadius,

          child: Stack(
            children: [

              // ==================================================
              // ZÁKLAD STARÉHO PAPÍRU
              // ==================================================

              Positioned.fill(
                child: DecoratedBox(
                  decoration:
                      BoxDecoration(
                    gradient:
                        LinearGradient(
                      begin:
                          isLeft
                              ? Alignment.centerRight
                              : Alignment.centerLeft,

                      end:
                          isLeft
                              ? Alignment.centerLeft
                              : Alignment.centerRight,

                      colors: const [
                        Color(
                          0xFFCDB28C,
                        ),

                        Color(
                          0xFFE3D0B1,
                        ),

                        Color(
                          0xFFF1E4D0,
                        ),

                        Color(
                          0xFFE5D1B1,
                        ),

                        Color(
                          0xFFC7A982,
                        ),
                      ],

                      stops: const [
                        0.00,
                        0.12,
                        0.50,
                        0.88,
                        1.00,
                      ],
                    ),
                  ),
                ),
              ),

              // ==================================================
              // SVĚTELNÉ STÁRNUTÍ
              // ==================================================

              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration:
                        BoxDecoration(
                      gradient:
                          RadialGradient(
                        center:
                            Alignment(
                          isLeft
                              ? -0.55
                              : 0.55,

                          -0.65,
                        ),

                        radius: 1.2,

                        colors: [
                          const Color(
                            0xFFFFF9E9,
                          ).withValues(
                            alpha: 0.48,
                          ),

                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // ZTMAVENÉ OKRAJE
              // ==================================================

              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration:
                        BoxDecoration(
                      gradient:
                          RadialGradient(
                        center:
                            Alignment.center,

                        radius: 0.72,

                        colors: [
                          Colors.transparent,

                          const Color(
                            0xFF9B754D,
                          ).withValues(
                            alpha: 0.10,
                          ),

                          const Color(
                            0xFF67472D,
                          ).withValues(
                            alpha: 0.28,
                          ),
                        ],

                        stops: const [
                          0.52,
                          0.80,
                          1.00,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // STÁRNUTÍ SHORA / ZDOLA
              // ==================================================

              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin:
                            Alignment.topCenter,

                        end:
                            Alignment.bottomCenter,

                        colors: [
                          const Color(
                            0xFF795536,
                          ).withValues(
                            alpha: 0.13,
                          ),

                          Colors.transparent,

                          const Color(
                            0xFF765333,
                          ).withValues(
                            alpha: 0.16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // PRASKLINY + SKVRNY + ŠKRÁBANCE
              // ==================================================

              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter:
                        _OldPaperPainter(
                      isLeft:
                          isLeft,
                    ),
                  ),
                ),
              ),

              // ==================================================
              // OPOTŘEBOVANÝ HORNÍ ROH
              // ==================================================

              Positioned(
                top: 0,

                left:
                    isLeft
                        ? 0
                        : null,

                right:
                    isLeft
                        ? null
                        : 0,

                child: IgnorePointer(
                  child:
                      _WornCorner(
                    top: true,
                    left:
                        isLeft,
                  ),
                ),
              ),

              // ==================================================
              // OPOTŘEBOVANÝ DOLNÍ ROH
              // ==================================================

              Positioned(
                bottom: 0,

                left:
                    isLeft
                        ? 0
                        : null,

                right:
                    isLeft
                        ? null
                        : 0,

                child: IgnorePointer(
                  child:
                      _WornCorner(
                    top: false,
                    left:
                        isLeft,
                  ),
                ),
              ),

              // ==================================================
              // OBSAH
              // ==================================================

              Positioned.fill(
                child:
                    child,
              ),

              // ==================================================
              // STÍN U HŘBETU
              // ==================================================

              IgnorePointer(
                child: Align(
                  alignment:
                      isLeft
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                  child: Container(
                    width: 30,

                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin:
                            isLeft
                                ? Alignment.centerRight
                                : Alignment.centerLeft,

                        end:
                            isLeft
                                ? Alignment.centerLeft
                                : Alignment.centerRight,

                        colors: [
                          Colors.black
                              .withValues(
                            alpha: 0.24,
                          ),

                          Colors.black
                              .withValues(
                            alpha: 0.09,
                          ),

                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // ČÍSLO STRÁNKY
              //
              // MALÉ ČÍSLO JE ZDE ZÁMĚRNĚ ODSTRANĚNO.
              //
              // Velké:
              //      — 1 —
              //      — 2 —
              //
              // zůstává v BookLeftPage / BookRightPage.
              // ==================================================
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// STARÝ PAPÍR – PRASKLINY, SKVRNY, ŠKRÁBANCE
// ============================================================

class _OldPaperPainter
    extends CustomPainter {
  final bool isLeft;

  _OldPaperPainter({
    required this.isLeft,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    // ========================================================
    // SKVRNY
    // ========================================================

    final stainPaint =
        Paint()
          ..style =
              PaintingStyle.fill;

    final stains = [
      Offset(
        size.width * 0.10,
        size.height * 0.24,
      ),

      Offset(
        size.width * 0.86,
        size.height * 0.17,
      ),

      Offset(
        size.width * 0.78,
        size.height * 0.72,
      ),

      Offset(
        size.width * 0.20,
        size.height * 0.82,
      ),

      Offset(
        size.width * 0.52,
        size.height * 0.54,
      ),
    ];

    for (
      var i = 0;
      i < stains.length;
      i++
    ) {
      final point =
          stains[i];

      stainPaint.color =
          const Color(
        0xFF8B633F,
      ).withValues(
        alpha:
            i.isEven
                ? 0.045
                : 0.025,
      );

      canvas.drawCircle(
        point,

        size.width *
            (i.isEven
                ? 0.025
                : 0.018),

        stainPaint,
      );
    }

    // ========================================================
    // PRASKLINY
    // ========================================================

    final crackPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              0.75
          ..strokeCap =
              StrokeCap.round;

    final cracks = [
      [
        Offset(
          size.width * 0.07,
          size.height * 0.14,
        ),

        Offset(
          size.width * 0.11,
          size.height * 0.22,
        ),

        Offset(
          size.width * 0.08,
          size.height * 0.31,
        ),
      ],

      [
        Offset(
          size.width * 0.90,
          size.height * 0.32,
        ),

        Offset(
          size.width * 0.84,
          size.height * 0.40,
        ),

        Offset(
          size.width * 0.88,
          size.height * 0.48,
        ),
      ],

      [
        Offset(
          size.width * 0.22,
          size.height * 0.70,
        ),

        Offset(
          size.width * 0.27,
          size.height * 0.76,
        ),

        Offset(
          size.width * 0.25,
          size.height * 0.86,
        ),
      ],

      [
        Offset(
          size.width * 0.73,
          size.height * 0.58,
        ),

        Offset(
          size.width * 0.68,
          size.height * 0.65,
        ),

        Offset(
          size.width * 0.71,
          size.height * 0.73,
        ),
      ],
    ];

    for (
      final points
          in cracks
    ) {
      final path =
          Path();

      path.moveTo(
        points[0].dx,
        points[0].dy,
      );

      path.lineTo(
        points[1].dx,
        points[1].dy,
      );

      path.lineTo(
        points[2].dx,
        points[2].dy,
      );

      crackPaint.color =
          const Color(
        0xFF65452E,
      ).withValues(
        alpha: 0.16,
      );

      canvas.drawPath(
        path,
        crackPaint,
      );
    }

    // ========================================================
    // JEMNÉ VLÁKNA / ŠKRÁBANCE
    // ========================================================

    final scratchPaint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              0.45;

    for (
      var i = 0;
      i < 12;
      i++
    ) {
      final y =
          size.height *
              (0.08 +
                  i *
                      0.075);

      final path =
          Path();

      path.moveTo(
        size.width *
            0.05,
        y,
      );

      path.quadraticBezierTo(
        size.width *
            0.40,

        y - 2,

        size.width *
            0.95,

        y + 1.5,
      );

      scratchPaint.color =
          const Color(
        0xFF8A6849,
      ).withValues(
        alpha: 0.035,
      );

      canvas.drawPath(
        path,
        scratchPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _OldPaperPainter oldDelegate,
  ) {
    return oldDelegate.isLeft !=
        isLeft;
  }
}

// ============================================================
// OPOTŘEBOVANÝ ROH
// ============================================================

class _WornCorner
    extends StatelessWidget {
  final bool top;
  final bool left;

  const _WornCorner({
    required this.top,
    required this.left,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return CustomPaint(
      size:
          const Size(
        65,
        65,
      ),

      painter:
          _WornCornerPainter(
        top:
            top,
        left:
            left,
      ),
    );
  }
}

// ============================================================
// VYKRESLENÍ OPOTŘEBOVANÉHO ROHU
// ============================================================

class _WornCornerPainter
    extends CustomPainter {
  final bool top;
  final bool left;

  _WornCornerPainter({
    required this.top,
    required this.left,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint =
        Paint()
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              1.0
          ..strokeCap =
              StrokeCap.round
          ..color =
              const Color(
            0xFF765333,
          ).withValues(
            alpha: 0.30,
          );

    final path =
        Path();

    final sx =
        left
            ? 0.0
            : size.width;

    final sy =
        top
            ? 0.0
            : size.height;

    path.moveTo(
      sx,
      sy,
    );

    path.lineTo(
      left
          ? size.width *
              0.55
          : size.width *
              0.45,

      sy,
    );

    path.lineTo(
      left
          ? size.width *
              0.40
          : size.width *
              0.60,

      top
          ? size.height *
              0.30
          : size.height *
              0.70,
    );

    path.lineTo(
      sx,

      top
          ? size.height *
              0.55
          : size.height *
              0.45,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _WornCornerPainter oldDelegate,
  ) {
    return false;
  }
}