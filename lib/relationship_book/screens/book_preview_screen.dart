import 'package:flutter/material.dart';

import '../theme/book_theme.dart';
import '../widgets/book_quote.dart';
import '../widgets/chapter_title.dart';
import '../widgets/eros_voice.dart';
import '../widgets/memory_block.dart';
import '../widgets/open_book.dart';
import '../widgets/page_number.dart';
import '../widgets/photo_frame.dart';

class BookPreviewScreen extends StatelessWidget {
  const BookPreviewScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BookTheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: OpenBook(
              leftPage: _buildLeftPage(),
              rightPage: _buildRightPage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        38,
        36,
        38,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const ChapterTitle(
            chapter: "Kapitola I",
            title: "Jak jsme se poznali",
            date: "15. srpna 2026",
          ),

          const SizedBox(height: 18),

          const BookQuote(
            quote:
                "Některé okamžiky netrvají dlouho.\nVzpomínky ano.",
          ),

          const SizedBox(height: 28),

          const Text(
            "Toho dne jsme ještě netušili, že právě obyčejné setkání se stane začátkem našeho společného příběhu.",
            style: TextStyle(
              fontSize: 18,
              height: 1.8,
            ),
          ),

          const SizedBox(height: 32),

          const ErosVoice(
            text:
                "Domov není místo.\nDomov jsme my.",
          ),

          const Spacer(),

          const PageNumber(
            page: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildRightPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        34,
        28,
        34,
        24,
      ),
      child: Column(
        children: [

          const PhotoFrame(),

          const SizedBox(height: 10),

          const MemoryBlock(
            author: "Luděk",
            text:
                "Nikdy bych nevěřil, že z obyčejného dne vznikne něco tak výjimečného.",
          ),

          const SizedBox(height: 8),

          const MemoryBlock(
            author: "Partnerka",
            text:
                "Pamatuji si hlavně ten pocit klidu a úsměv, který jsem ten den viděla.",
          ),

          const Spacer(),

          const PageNumber(
            page: 2,
          ),
        ],
      ),
    );
  }
}