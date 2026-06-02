import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class RescueVoteOverlay
    extends StatefulWidget {
  final List<String> voterNames;

  final VoidCallback onSuccess;

  final VoidCallback onFail;

  const RescueVoteOverlay({
    super.key,
    required this.voterNames,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  State<RescueVoteOverlay>
      createState() =>
          _RescueVoteOverlayState();
}

class _RescueVoteOverlayState
    extends State<
        RescueVoteOverlay> {
  int _currentVoter = 0;

  int _yesVotes = 0;

  void _vote(bool yes) {
    if (yes) {
      _yesVotes++;
    }

    setState(() {
      _currentVoter++;
    });

    // konec hlasování
    if (_currentVoter >=
        widget.voterNames.length) {
      Future.delayed(
        const Duration(
          milliseconds: 600,
        ),
        () {
          if (_yesVotes >
              widget.voterNames
                      .length /
                  2) {
            widget.onSuccess();
          } else {
            widget.onFail();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context);

    if (_currentVoter >=
        widget.voterNames.length) {
      return const SizedBox
          .shrink();
    }

    final voter =
        widget.voterNames[
            _currentVoter];

    return Scaffold(
      backgroundColor:
          Colors.black,

      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(
            32,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Text(
                l10n.rescueTitle,
                style:
                    const TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight
                          .bold,
                  color:
                      Colors
                          .redAccent,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              Text(
                l10n
                    .givePhoneToPlayer,
                style:
                    const TextStyle(
                  fontSize: 18,
                  color:
                      Colors
                          .white70,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Text(
                voter,
                style:
                    const TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight
                          .bold,
                  color:
                      Colors.white,
                ),
              ),

              const SizedBox(
                height: 32,
              ),

              Text(
                l10n
                    .rescueQuestion,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  fontSize: 22,
                  color:
                      Colors.white,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors.green,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 16,
                      ),
                    ),

                    onPressed:
                        () =>
                            _vote(
                      true,
                    ),

                    child: Text(
                      l10n.yes,
                      style:
                          const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors.red,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 16,
                      ),
                    ),

                    onPressed:
                        () =>
                            _vote(
                      false,
                    ),

                    child: Text(
                      l10n.no,
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
      ),
    );
  }
}