import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';

class BookLeftPage extends StatelessWidget {
  final RelationshipChapter chapter;
  final int chapterNumber;
  final String? motto;

  const BookLeftPage({
    super.key,
    required this.chapter,
    required this.chapterNumber,
    required this.motto,
  });

  String _formatDate(DateTime date) {
    return "${date.day}. ${date.month}. ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        44,
        42,
        44,
        28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "KAPITOLA $chapterNumber",
            style: TextStyle(
              color: Colors.brown.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            chapter.chapterTitle,
            style: TextStyle(
              color: Colors.brown.shade900,
              fontSize: 38,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            _formatDate(chapter.createdAt),
            style: TextStyle(
              color: Colors.brown.shade500,
              fontStyle: FontStyle.italic,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 18),

          Center(
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.brown.shade300,
            ),
          ),

          if (motto != null && motto!.trim().isNotEmpty) ...[
            const SizedBox(height: 26),

            Text(
              '"$motto"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.brown.shade800,
                fontSize: 20,
                fontStyle: FontStyle.italic,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 24),

            Divider(
              color: Colors.brown.shade200,
              thickness: 1,
            ),

            const SizedBox(height: 26),
          ],

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                chapter.introduction,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.brown.shade900,
                  fontSize: 19,
                  height: 2.0,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF4ECE2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.brown.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EROS VOICE",
                  style: TextStyle(
                    color: Colors.brown.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Místo pro Eros Voice.",
                  style: TextStyle(
                    color: Colors.brown.shade800,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          Center(
            child: Text(
              "— $chapterNumber —",
              style: TextStyle(
                color: Colors.brown.shade700,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}