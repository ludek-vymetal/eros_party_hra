import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class RescueOverlay
    extends StatelessWidget {
  final String voterName;

  final String rescuedName;

  final VoidCallback onYes;

  final VoidCallback onNo;

  const RescueOverlay({
    super.key,
    required this.voterName,
    required this.rescuedName,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Container(
      color: Colors.black
          .withValues(
        alpha: 0.9,
      ),

      child: Center(
        child: Container(
          padding:
              const EdgeInsets.all(
            32,
          ),

          decoration:
              BoxDecoration(
            color:
                const Color(
              0xFF1A0F14,
            ),

            borderRadius:
                BorderRadius.circular(
              24,
            ),

            border: Border.all(
              color:
                  Colors.redAccent,
              width: 2,
            ),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Text(
                l10n.rescueTitle,
                style:
                    const TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight
                          .bold,
                  color:
                      Colors
                          .redAccent,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Text(
                '${l10n.rescuedPlayer}\n$rescuedName',
                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight
                          .bold,
                  color:
                      Colors.white,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                '${l10n.votingPlayer}\n$voterName',
                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  fontSize: 20,
                  color:
                      Colors
                          .white70,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              ElevatedButton(
                onPressed: onYes,

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors.green,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),

                child: Text(
                  l10n.yes,
                  style:
                      const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              ElevatedButton(
                onPressed: onNo,

                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      Colors
                          .redAccent,

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),

                child: Text(
                  l10n.no,
                  style:
                      const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}