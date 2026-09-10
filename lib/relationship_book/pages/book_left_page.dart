import 'package:flutter/material.dart';

import '../models/relationship_chapter.dart';
import '../models/relationship_reflection.dart';
import '../widgets/memory_block.dart';

class BookLeftPage extends StatelessWidget {
  final RelationshipChapter chapter;
  final int chapterNumber;
  final int pageNumber;
  final String? motto;
  final RelationshipReflection? partnerReflection;
  final VoidCallback? onPreviousPage;

  const BookLeftPage({
    super.key,
    required this.chapter,
    required this.chapterNumber,
    required this.pageNumber,
    required this.motto,
    required this.partnerReflection,
    this.onPreviousPage,
  });

  String _formatDate(DateTime date) {
    return "${date.day}. ${date.month}. ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation ==
            Orientation.portrait;

    // ==========================================================
    // MOBIL
    // ==========================================================

    final horizontalPadding =
        isPortrait ? 24.0 : 44.0;

    final topPadding =
        isPortrait ? 28.0 : 42.0;

    final bottomPadding =
        isPortrait ? 20.0 : 28.0;

    final chapterFontSize =
        isPortrait ? 12.0 : 13.0;

    final titleFontSize =
        isPortrait ? 27.0 : 38.0;

    final dateFontSize =
        isPortrait ? 13.0 : 15.0;

    final bodyFontSize =
        isPortrait ? 16.0 : 19.0;

    final bodyLineHeight =
        isPortrait ? 1.65 : 2.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        bottomPadding,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ======================================================
          // KAPITOLA
          // ======================================================

          Text(
            "KAPITOLA $chapterNumber",
            style: TextStyle(
              color: Colors.brown.shade600,
              fontSize: chapterFontSize,
              fontWeight:
                  FontWeight.w600,
              letterSpacing:
                  isPortrait ? 3.2 : 4,
            ),
          ),

          SizedBox(
            height:
                isPortrait ? 10 : 14,
          ),

          // ======================================================
          // NADPIS
          // ======================================================

          Text(
            chapter.chapterTitle,
            style: TextStyle(
              color: Colors.brown.shade900,
              fontSize: titleFontSize,
              fontWeight:
                  FontWeight.bold,
              height: 1.15,
            ),
          ),

          SizedBox(
            height:
                isPortrait ? 7 : 10,
          ),

          // ======================================================
          // DATUM
          // ======================================================

          Text(
            _formatDate(
              chapter.createdAt,
            ),
            style: TextStyle(
              color: Colors.brown.shade500,
              fontStyle:
                  FontStyle.italic,
              fontSize: dateFontSize,
            ),
          ),

          SizedBox(
            height:
                isPortrait ? 12 : 18,
          ),

          // ======================================================
          // LINKA
          // ======================================================

          Container(
            width: double.infinity,
            height: 1,
            color: Colors.brown.shade300,
          ),

          // ======================================================
          // MOTTO
          // ======================================================

          if (motto != null &&
              motto!.trim().isNotEmpty) ...[
            SizedBox(
              height:
                  isPortrait ? 18 : 26,
            ),

            Text(
              '"$motto"',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color:
                    Colors.brown.shade800,
                fontSize:
                    isPortrait ? 16 : 20,
                fontStyle:
                    FontStyle.italic,
                height:
                    isPortrait ? 1.5 : 1.7,
              ),
            ),

            SizedBox(
              height:
                  isPortrait ? 16 : 24,
            ),

            Divider(
              color:
                  Colors.brown.shade200,
              thickness: 1,
            ),

            SizedBox(
              height:
                  isPortrait ? 16 : 26,
            ),
          ],

          // ======================================================
          // HLAVNÍ TEXT
          // ======================================================

          Expanded(
            child:
                SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.introduction,
                    textAlign:
                        TextAlign.justify,
                    style: TextStyle(
                      color:
                          Colors.brown.shade900,
                      fontSize:
                          bodyFontSize,
                      height:
                          bodyLineHeight,
                    ),
                  ),

                  // ==================================================
                  // PARTNEROVA REFLEXE
                  // ==================================================

                  if (partnerReflection !=
                      null) ...[
                    SizedBox(
                      height:
                          isPortrait ? 18 : 26,
                    ),

                    MemoryBlock(
                      author: "Partner",
                      text:
                          partnerReflection!
                              .text,
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(
            height:
                isPortrait ? 12 : 16,
          ),

          // ======================================================
          // EROS VOICE
          // ======================================================

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal:
                  isPortrait ? 16 : 24,
              vertical:
                  isPortrait ? 13 : 18,
            ),
            decoration:
                BoxDecoration(
              color:
                  const Color(0xFFF4ECE2),
              borderRadius:
                  BorderRadius.circular(
                isPortrait ? 11 : 14,
              ),
              border: Border.all(
                color:
                    Colors.brown.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "EROS VOICE",
                  style: TextStyle(
                    color:
                        Colors.brown.shade700,
                    fontSize:
                        isPortrait ? 9 : 11,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing:
                        isPortrait ? 1.6 : 2,
                  ),
                ),

                SizedBox(
                  height:
                      isPortrait ? 6 : 8,
                ),

                Text(
                  "Místo pro Eros Voice.",
                  style: TextStyle(
                    color:
                        Colors.brown.shade800,
                    fontStyle:
                        FontStyle.italic,
                    fontSize:
                        isPortrait ? 13 : 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height:
                isPortrait ? 10 : 20,
          ),

          // ======================================================
          // ČÍSLO STRÁNKY
          // ======================================================

          Center(
            child: GestureDetector(
              onTap: onPreviousPage,
              child: MouseRegion(
                cursor:
                    SystemMouseCursors.click,
                child: Padding(
                  padding:
                      const EdgeInsets.all(4),
                  child: Text(
                    "— $pageNumber —",
                    style: TextStyle(
                      color:
                          Colors.brown.shade800,
                      fontSize:
                          isPortrait ? 15 : 18,
                      fontStyle:
                          FontStyle.italic,
                      fontWeight:
                          FontWeight.w500,
                    ),
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