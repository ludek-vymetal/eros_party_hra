import 'package:flutter/material.dart';

import '../theme/book_theme.dart';

class BookPage extends StatelessWidget {
  final Widget child;

  const BookPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        BookTheme.pagePadding,
      ),
      decoration: BoxDecoration(
        color: BookTheme.paperLeft,
        borderRadius: BorderRadius.circular(
          BookTheme.borderRadius,
        ),
      ),
      child: child,
    );
  }
}