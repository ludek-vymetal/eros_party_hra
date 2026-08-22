import 'package:flutter/material.dart';

class BookPager extends StatefulWidget {
  final List<Widget> spreads;

  const BookPager({
    super.key,
    required this.spreads,
  });

  @override
  State<BookPager> createState() => _BookPagerState();
}

class _BookPagerState extends State<BookPager> {
  int currentSpread = 0;

  @override
  void didUpdateWidget(covariant BookPager oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Pokud se změnil počet stran, zajistíme,
    // aby index stále ukazoval na existující stránku.
    if (currentSpread >= widget.spreads.length) {
      currentSpread =
          widget.spreads.isEmpty
              ? 0
              : widget.spreads.length - 1;
    }
  }

  void nextSpread() {
    if (currentSpread >= widget.spreads.length - 1) {
      return;
    }

    setState(() {
      currentSpread++;
    });
  }

  void previousSpread() {
    if (currentSpread <= 0) {
      return;
    }

    setState(() {
      currentSpread--;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'BOOK PAGER BUILD - spread: $currentSpread',
    );

    if (widget.spreads.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(
            milliseconds: 500,
          ),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (
            child,
            animation,
          ) {
            final slide = Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },

          // DŮLEŽITÉ:
          // stránka dostane novou Key při změně
          // obsahu BookPageru.
          child: KeyedSubtree(
            key: ValueKey(
              'spread_${currentSpread}_${widget.spreads[currentSpread].hashCode}',
            ),
            child: widget.spreads[currentSpread],
          ),
        ),

        Positioned(
          left: 10,
          top: 10,
          child: Container(
            color: Colors.red,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              iconSize: 60,
              onPressed: previousSpread,
            ),
          ),
        ),

        Positioned(
          right: 10,
          top: 10,
          child: Container(
            color: Colors.red,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              iconSize: 60,
              onPressed: nextSpread,
            ),
          ),
        ),
      ],
    );
  }
}