import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class PartyConsentScreen
    extends StatelessWidget {
  const PartyConsentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          const Color(0xFF0F0A0D),

      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 520,
          ),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(
                    alpha: 0.6,
                  ),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  l10n
                      .partyConsentTitle,
                  style:
                      const TextStyle(
                    fontSize: 26,
                    fontWeight:
                        FontWeight
                            .bold,
                    color: Color(
                      0xFFF5E6E8,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                Text(
                  l10n
                      .partyConsentScreenText,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: Color(
                      0xFFE6C7CE,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 36,
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar:
          Padding(
        padding:
            const EdgeInsets.fromLTRB(
          24,
          0,
          24,
          24,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(false);
                },
                child: Text(
                  l10n.disagree,
                  style:
                      const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(true);
                },
                child: Text(
                  l10n.agree,
                  style:
                      const TextStyle(
                    fontSize: 16,
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