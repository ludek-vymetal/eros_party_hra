import 'package:flutter/material.dart';

class LeftPage extends StatelessWidget {
  final String chapter;
  final String title;
  final String date;
  final String quote;
  final String story;

  const LeftPage({
    super.key,
    required this.chapter,
    required this.title,
    required this.date,
    required this.quote,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chapter.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 4,
            fontSize: 14,
            color: Colors.brown,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          title,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Color(0xff4b2e2b),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          date,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.brown,
          ),
        ),

        const Divider(height: 40),

        Center(
          child: Text(
            quote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20,
            ),
          ),
        ),

        const SizedBox(height: 40),

        Expanded(
          child: Text(
            story,
            style: const TextStyle(
              height: 1.7,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}