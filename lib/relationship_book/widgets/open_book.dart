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
          boxShadow: [
            BoxShadow(
              blurRadius: 35,
              color: Colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _BookPage(
                child: leftPage,
                isLeft: true,
              ),
            ),

            Container(
              width: 22,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.brown.shade900,
                    Colors.brown.shade700,
                    Colors.brown.shade500,
                    Colors.brown.shade700,
                    Colors.brown.shade900,
                  ],
                ),
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
        color: BookTheme.paperColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            isLeft ? 8 : 2,
          ),
          bottomLeft: Radius.circular(
            isLeft ? 8 : 2,
          ),
          topRight: Radius.circular(
            isLeft ? 2 : 8,
          ),
          bottomRight: Radius.circular(
            isLeft ? 2 : 8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withValues(alpha: 0.12),
            offset: Offset(
              isLeft ? -2 : 2,
              0,
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}