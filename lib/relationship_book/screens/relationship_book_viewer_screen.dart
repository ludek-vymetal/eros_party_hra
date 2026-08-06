import 'package:flutter/material.dart';

class RelationshipBookViewerScreen extends StatefulWidget {
  final List<Widget> spreads;

  const RelationshipBookViewerScreen({
    super.key,
    required this.spreads,
  });

  @override
  State<RelationshipBookViewerScreen> createState() =>
      _RelationshipBookViewerScreenState();
}

class _RelationshipBookViewerScreenState
    extends State<RelationshipBookViewerScreen> {
  int currentSpread = 0;

  void nextSpread() {
    if (currentSpread >= widget.spreads.length - 1) return;

    setState(() {
      currentSpread++;
    });
  }

  void previousSpread() {
    if (currentSpread <= 0) return;

    setState(() {
      currentSpread--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFD9C3A0),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: size.width * 0.80,
                height: size.height * 0.88,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: KeyedSubtree(
                    key: ValueKey(currentSpread),
                    child: widget.spreads[currentSpread],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 18,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.white.withOpacity(0.70),
                  elevation: 6,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left),
                    iconSize: 42,
                    color: Colors.brown.shade700,
                    onPressed: previousSpread,
                  ),
                ),
              ),
            ),

            Positioned(
              right: 18,
              top: 0,
              bottom: 0,
              child: Center(
                child: Material(
                  color: Colors.white.withOpacity(0.70),
                  elevation: 6,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right),
                    iconSize: 42,
                    color: Colors.brown.shade700,
                    onPressed: nextSpread,
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