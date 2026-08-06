import 'package:flutter/material.dart';

import '../theme/book_theme.dart';

class OpenBook extends StatelessWidget {
  final Widget leftPage;
  final Widget rightPage;

  const OpenBook({
    super.key,
    required this.leftPage,
    required this.rightPage,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.65,
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
                  child: leftPage,
                  isLeft: true,
                ),
              ),

              // =========================
              // HŘBET KNIHY
              // =========================

              Container(
                width: 26,
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
                  child: rightPage,
                  isLeft: false,
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

  const _BookPage({
    required this.child,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isLeft
            ? BookTheme.paperLeft
            : BookTheme.paperRight,
        gradient: LinearGradient(
          begin:
              isLeft ? Alignment.centerRight : Alignment.centerLeft,
          end:
              isLeft ? Alignment.centerLeft : Alignment.centerRight,
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
    );
  }
}