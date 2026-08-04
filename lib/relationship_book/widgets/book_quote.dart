import 'package:flutter/material.dart';

import '../theme/book_theme.dart';

class BookQuote extends StatelessWidget {
  final String quote;

  const BookQuote({
    super.key,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          '"$quote"',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: BookTheme.title,
            fontSize: 22,
            fontStyle: FontStyle.italic,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}