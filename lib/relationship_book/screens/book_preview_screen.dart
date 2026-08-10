import 'package:flutter/material.dart';

// ===========================================================================
// 1. MODELY (Simulace dat, která by běžně byla v samostatných souborech)
// ===========================================================================

class RelationshipChapter {
  final String id;
  final int chapterNumber;
  final String chapterTitle;
  final DateTime createdAt;
  final String introduction;
  final String? customMotto;

  RelationshipChapter({
    required this.id,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.createdAt,
    required this.introduction,
    this.customMotto,
  });
}

class RelationshipPhoto {
  final String id;
  final String chapterId;
  final String storagePath; // V tomto demu nepoužito, pro reálné foto použij File

  RelationshipPhoto({
    required this.id,
    required this.chapterId,
    required this.storagePath,
  });
}

class RelationshipReflection {
  final String id;
  final String chapterId;
  final String author;
  final String text;

  RelationshipReflection({
    required this.id,
    required this.chapterId,
    required this.author,
    required this.text,
  });
}

// ===========================================================================
// 2. TÉMA A KONSTANTY
// ===========================================================================

class BookTheme {
  static const Color background = Color(0xFFE8DCCA);
  static const Color paperLeft = Color(0xFFFDF8F1);
  static const Color paperRight = Color(0xFFFAF3E8);
  static const Color accent = Color(0xFF8B5A2B);
}

// ===========================================================================
// 3. POMOCNÉ WIDGETY (Upravené pro provoz v jednom souboru)
// ===========================================================================

class ChapterTitle extends StatelessWidget {
  final String chapter;
  final String title;
  final String date;

  const ChapterTitle({
    super.key,
    required this.chapter,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(chapter.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: BookTheme.accent)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.1)),
        const SizedBox(height: 8),
        Text(date, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
        const SizedBox(height: 16),
        Container(height: 1, color: BookTheme.accent.withValues(alpha: .3)),
      ],
    );
  }
}

class BookQuote extends StatelessWidget {
  final String quote;

  const BookQuote({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: BookTheme.accent.withValues(alpha: .2)), borderRadius: BorderRadius.circular(8)),
      child: Text(quote, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.5, color: BookTheme.accent)),
    );
  }
}

class ErosVoice extends StatelessWidget {
  final String text;

  const ErosVoice({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("EROS VOICE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: BookTheme.accent)),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)),
      ],
    );
  }
}

class PageNumber extends StatelessWidget {
  final int page;
  final VoidCallback? onTap;

  const PageNumber({super.key, required this.page, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text("— $page —", style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: BookTheme.accent)),
      ),
    );
  }
}

class PhotoFrame extends StatelessWidget {
  final VoidCallback? onTap;

  const PhotoFrame({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    // V tomto demu jen placeholder, pro reálné foto použij Image.file
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade400)),
        child: InkWell(
          onTap: onTap,
          child: const Center(child: Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey)),
        ),
      ),
    );
  }
}

class MemoryBlock extends StatelessWidget {
  final String author;
  final String text;
  final VoidCallback? onTap;

  const MemoryBlock({super.key, required this.author, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(author, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BookTheme.accent)),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)),
        ],
      ),
    );
  }
}

// ===========================================================================
// 4. STRÁNKY KNIHY (BookBuilder)
// ===========================================================================

class BookLeftPage extends StatelessWidget {
  final RelationshipChapter chapter;
  final int pageNumber;
  final VoidCallback? onPrevious;

  const BookLeftPage({super.key, required this.chapter, required this.pageNumber, this.onPrevious});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(38, 36, 38, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChapterTitle(
            chapter: "Kapitola ${chapter.chapterNumber}",
            title: chapter.chapterTitle,
            date: "${chapter.createdAt.day}. ${chapter.createdAt.month}. ${chapter.createdAt.year}",
          ),
          const SizedBox(height: 18),
          if (chapter.customMotto != null) BookQuote(quote: chapter.customMotto!),
          const SizedBox(height: 28),
          Expanded(
            child: SingleChildScrollView(
              child: Text(chapter.introduction, style: const TextStyle(fontSize: 18, height: 1.8)),
            ),
          ),
          const SizedBox(height: 32),
          const ErosVoice(text: "Zde bude Eros Voice..."),
          const SizedBox(height: 16),
          // Číslo stránky funguje jako tlačítko zpět
          PageNumber(page: pageNumber, onTap: onPrevious),
        ],
      ),
    );
  }
}

class BookRightPage extends StatelessWidget {
  final String chapterId;
  final int pageNumber;
  final List<RelationshipReflection> reflections;
  final VoidCallback? onNext;

  const BookRightPage({super.key, required this.chapterId, required this.pageNumber, required this.reflections, this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(34, 28, 34, 24),
      child: Column(
        children: [
          const PhotoFrame(),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var reflection in reflections)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: MemoryBlock(author: reflection.author, text: reflection.text),
                    ),
                  if (reflections.isEmpty) const MemoryBlock(author: "Systém", text: "Zatím žádné vzkazy..."),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Číslo stránky funguje jako tlačítko vpřed
          PageNumber(page: pageNumber, onTap: onNext),
        ],
      ),
    );
  }
}

class BookBuilder {
  static List<Widget> build({
    required List<RelationshipChapter> chapters,
    required List<RelationshipReflection> reflections,
    required PageController pageController,
  }) {
    return List.generate(chapters.length, (index) {
      final chapter = chapters[index];
      final chapterReflections = reflections.where((r) => r.chapterId == chapter.id).toList();

      final leftNumber = (index * 2) + 1;
      final rightNumber = (index * 2) + 2;

      void goToPrevious() {
        if (pageController.hasClients && index > 0) {
          pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
        }
      }

      void goToNext() {
        if (pageController.hasClients && index < chapters.length - 1) {
          pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
        }
      }

      return OpenBook(
        leftPageNumber: leftNumber,
        rightPageNumber: rightNumber,
        // Pro desktop: celostránková gesta
        onPrevious: goToPrevious,
        onNext: goToNext,
        leftPage: BookLeftPage(chapter: chapter, pageNumber: leftNumber, onPrevious: goToPrevious),
        rightPage: BookRightPage(chapterId: chapter.id, pageNumber: rightNumber, reflections: chapterReflections, onNext: goToNext),
      );
    });
  }
}

// ===========================================================================
// 5. WIDGET KNIHY (OpenBook - Upravený pro mobil i desktop)
// ===========================================================================

class OpenBook extends StatelessWidget {
  final Widget leftPage;
  final Widget rightPage;
  final int leftPageNumber;
  final int rightPageNumber;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const OpenBook({
    super.key,
    required this.leftPage,
    required this.rightPage,
    required this.leftPageNumber,
    required this.rightPageNumber,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    // Detekce orientace pro přizpůsobení mobilu
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return AspectRatio(
      // Oprava pro mobil: na výšku změníme poměr stran, aby kniha nebyla tak prťavá
      aspectRatio: isPortrait ? 1.0 : 1.65,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 35, spreadRadius: 2, offset: Offset(0, 18))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Expanded(child: _BookPage(isLeft: true, onPageTap: onPrevious, child: leftPage)),
              // HŘBET
              Container(
                width: isPortrait ? 15 : 25,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown.shade900, Colors.brown.shade700, Colors.brown.shade500, Colors.brown.shade300, Colors.brown.shade500, Colors.brown.shade700, Colors.brown.shade900],
                  ),
                ),
              ),
              Expanded(child: _BookPage(isLeft: false, onPageTap: onNext, child: rightPage)),
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
  final VoidCallback? onPageTap;

  const _BookPage({required this.child, required this.isLeft, this.onPageTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Celostránkové gesto pro přetáčení
      onTap: onPageTap,
      child: Container(
        color: isLeft ? BookTheme.paperLeft : BookTheme.paperRight,
        child: Stack(
          children: [
            child,
            // Stín u hřbetu
            Align(
              alignment: isLeft ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 15,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: isLeft ? Alignment.centerRight : Alignment.centerLeft,
                    end: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                    colors: [Colors.black.withValues(alpha: .05), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// 6. SAMOTNÁ OBRAZOVKA (BookPreviewScreen - Ostrý provoz s ukázkovými daty)
// ===========================================================================

class BookPreviewScreen extends StatefulWidget {
  const BookPreviewScreen({super.key});

  @override
  State<BookPreviewScreen> createState() => _BookPreviewScreenState();
}

class _BookPreviewScreenState extends State<BookPreviewScreen> {
  late final PageController _pageController;

  // UKÁZKOVÁ DATA (Pro demo účely vytváříme přímo zde)
  final List<RelationshipChapter> _chapters = [];
  final List<RelationshipReflection> _reflections = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // Inicializace dat
    _initDemoData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _initDemoData() {
    // Vytvoříme 3 kapitoly
    _chapters.addAll([
      RelationshipChapter(
        id: "cap1",
        chapterNumber: 1,
        chapterTitle: "Jak jsme se poznali",
        createdAt: DateTime(2026, 8, 15),
        introduction: "Toho dne jsme ještě netušili, že právě obyčejné setkání se stane začátkem našeho společného příběhu.\nPamatuji si ten okamžik, kdy se naše pohledy poprvé střetly. Bylo to v kavárně na rohu...",
        customMotto: "Některé okamžiky netrvají dlouho. Vzpomínky ano.",
      ),
      RelationshipChapter(
        id: "cap2",
        chapterNumber: 2,
        chapterTitle: "První rande",
        createdAt: DateTime(2026, 8, 20),
        introduction: "Bylo to nervózní, ale krásné. Káva, procházka parkem a spousta smíchu.\nI když pršelo, nám to vůbec nevadilo, protože jsme měli jeden druhého.",
      ),
      RelationshipChapter(
        id: "cap3",
        chapterNumber: 3,
        chapterTitle: "Naše první cesta",
        createdAt: DateTime(2026, 9, 10),
        introduction: "Sbalili jsme si batohy a vyrazili na hory. Byl to víkend plný dobrodružství, objevování a nezapomenutelných výhledů.",
        customMotto: "Cestování je nejlepší investice do vzpomínek.",
      ),
    ]);

    // Vytvoříme vzkazy
    _reflections.addAll([
      RelationshipReflection(id: "ref1", chapterId: "cap1", author: "Luděk", text: "Nikdy bych nevěřil, že z obyčejného dne vznikne něco tak výjimečného."),
      RelationshipReflection(id: "ref2", chapterId: "cap1", author: "Partnerka", text: "Pamatuji si hlavně ten pocit klidu a úsměv, který jsem ten den viděla."),
      RelationshipReflection(id: "ref3", chapterId: "cap2", author: "Luděk", text: "Byl jsem strašně nervózní, doufám, že to nebylo poznat."),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Vygenerujeme stránky knihy
    final bookPages = BookBuilder.build(
      chapters: _chapters,
      reflections: _reflections,
      pageController: _pageController,
    );

    return Scaffold(
      backgroundColor: BookTheme.background,
      appBar: AppBar(
        title: const Text("Tvá Kniha Příběhů"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: BookTheme.accent),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            // PageView pro listování
            child: PageView(
              controller: _pageController,
              children: bookPages,
            ),
          ),
        ),
      ),
    );
  }
}