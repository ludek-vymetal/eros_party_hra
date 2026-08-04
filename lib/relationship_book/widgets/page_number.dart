import 'package:flutter/material.dart';

import '../theme/book_theme.dart';

class PageNumber extends StatelessWidget {
  final int page;

  const PageNumber({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Center(
        child: Text(
          '— $page —',
          style: TextStyle(
            color: BookTheme.body.withValues(
              alpha: 0.75,
            ),
            fontSize: 17,
            letterSpacing: 1.4,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}