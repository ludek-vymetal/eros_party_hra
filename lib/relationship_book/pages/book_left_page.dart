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
        38,
        36,
        38,
        26,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "KAPITOLA $chapterNumber",
            style: TextStyle(
              color: Colors.brown.shade600,
              fontSize: 13,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            chapter.chapterTitle,
            style: TextStyle(
              color: Colors.brown.shade900,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _formatDate(chapter.createdAt),
            style: TextStyle(
              color: Colors.brown.shade500,
              fontStyle: FontStyle.italic,
              fontSize: 15,
            ),
          ),

          if (motto != null) ...[
            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF2EAE0),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.brown.shade200,
                ),
              ),
              child: Text(
                motto!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.brown.shade800,
                ),
              ),
            ),
          ],

          const SizedBox(height: 28),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                chapter.introduction,
                style: TextStyle(
                  color: Colors.brown.shade900,
                  fontSize: 18,
                  height: 1.8,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Center(
            child: Text(
              "— 1 —",
              style: TextStyle(
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