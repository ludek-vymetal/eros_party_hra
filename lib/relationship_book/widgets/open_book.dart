import 'package:flutter/material.dart';

import '../theme/book_theme.dart';

class OpenBook extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Detekujeme, zda jsme na výšku (mobil) nebo na šířku (desktop/tablet)
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return AspectRatio(
      // Zde je oprava: Na výšku dáme poměr blíž k čtverci (např. 1.1),
      // na šířku necháme původní širokoúhlý (1.65).
      aspectRatio: isPortrait ? 1.1 : 1.65, 
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Expanded(
                child: _BookPage(
                  pageNumber: leftPageNumber,
                  onPageTap: onPrevious,
                  isLeft: true,
                  child: leftPage,
                ),
              ),

              // =========================
              // HŘBET KNIHY
              // =========================

              Container(
                width: isPortrait ? 16 : 26, // Na mobilu zúžíme hřbet
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
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
                      color: Colors.black.withValues(alpha: .25),
                      blurRadius: 10,
                      offset: const Offset(-2, 0),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .25),
                      blurRadius: 10,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _BookPage(
                  pageNumber: rightPageNumber,
                  onPageTap: onNext,
                  isLeft: false,
                  child: rightPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPageTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLeft ? BookTheme.paperLeft : BookTheme.paperRight,
          gradient: LinearGradient(
            begin: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            end: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            colors: isLeft
                ? [
                    const Color(0xFFF4EBDD),
                    BookTheme.paperLeft,
                  ]
                : [
                    const Color(0xFFF4EBDD),
                    BookTheme.paperRight,
                  ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isLeft ? 14 : 3),
            bottomLeft: Radius.circular(isLeft ? 14 : 3),
            topRight: Radius.circular(isLeft ? 3 : 14),
            bottomRight: Radius.circular(isLeft ? 3 : 14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
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
                alignment:
                    isLeft ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 18,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: isLeft
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      end: isLeft
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: .08),
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