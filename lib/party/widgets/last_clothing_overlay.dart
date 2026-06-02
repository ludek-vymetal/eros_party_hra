import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class LastClothingOverlay
    extends StatefulWidget {
  final String playerName;

  final String clothing;

  final VoidCallback onFinish;

  const LastClothingOverlay({
    super.key,
    required this.playerName,
    required this.clothing,
    required this.onFinish,
  });

  @override
  State<LastClothingOverlay>
      createState() =>
          _LastClothingOverlayState();
}

class _LastClothingOverlayState
    extends State<
        LastClothingOverlay>
    with TickerProviderStateMixin {
  late AnimationController
      _controller;

  late Animation<double> _fade;

  late Animation<double> _scale;

  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 4,
      ),
    );

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scale = Tween<double>(
      begin: 0.7,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    Future.delayed(
      const Duration(seconds: 4),
      () {
        if (!mounted) return;

        setState(() {
          _showButton = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      backgroundColor:
          Colors.black,

      body: FadeTransition(
        opacity: _fade,

        child: Stack(
          alignment:
              Alignment.center,

          children: [
            // 🔥 BACKGROUND
            Container(
              decoration:
                  const BoxDecoration(
                gradient:
                    RadialGradient(
                  colors: [
                    Color(
                      0xFF8B0000,
                    ),
                    Colors.black,
                  ],
                  radius: 1.2,
                ),
              ),
            ),

            Column(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,
              children: [
                Text(
                  l10n.lastClothing,
                  style:
                      const TextStyle(
                    fontSize: 24,
                    letterSpacing: 3,
                    color:
                        Colors.redAccent,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                ScaleTransition(
                  scale: _scale,

                  child: Text(
                    widget.clothing,
                    textAlign:
                        TextAlign
                            .center,
                    style:
                        const TextStyle(
                      fontSize: 56,
                      fontWeight:
                          FontWeight
                              .bold,
                      color:
                          Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius:
                              20,
                          color:
                              Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Text(
                  '${widget.playerName} '
                  '${l10n.nothingToHide}',
                  style:
                      const TextStyle(
                    fontSize: 22,
                    color:
                        Colors.white70,
                    fontStyle:
                        FontStyle
                            .italic,
                  ),
                ),

                const SizedBox(
                  height: 60,
                ),

                if (_showButton)
                  ElevatedButton(
                    onPressed:
                        widget.onFinish,

                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors
                              .redAccent,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),

                    child: Text(
                      l10n
                          .continueText,
                      style:
                          const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}