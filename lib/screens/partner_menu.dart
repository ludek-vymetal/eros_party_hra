import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'settings_screen.dart';
import 'partner_write.dart';
import 'partner_read.dart';
import 'partner_link_screen.dart';
import 'scenario_record_list_screen.dart';
import 'statistics_screen.dart';
import 'cloud_partner_inbox_screen.dart';
import 'favorite_scenarios_screen.dart';
import 'community_scenarios_screen.dart';
import 'relationship_journal_screen.dart';
import '../services/partner_link_service.dart';

import 'cloud_partner_reactions_screen.dart';

class PartnerMenuScreen
    extends StatefulWidget {
  const PartnerMenuScreen({
    super.key,
  });

  @override
  State<PartnerMenuScreen>
      createState() =>
          _PartnerMenuScreenState();
}

class _PartnerMenuScreenState
    extends State<PartnerMenuScreen> {
  static const bgColor =
      Color(0xFF12080c);

  static const accent =
      Color(0xFF8b1e3f);

  bool linked = false;

  @override
  void initState() {
    super.initState();

    _loadLink();
  }

  Future<void> _loadLink() async {
    final isLinked =
        await PartnerLinkService
            .isLinked();

    if (!mounted) return;

    setState(() {
      linked = isLinked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context);

    return Scaffold(
      backgroundColor:
          bgColor,

      // ⬅️ BACK
      appBar: AppBar(
        backgroundColor:
            bgColor,

        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),

          onPressed: () {
            Navigator.of(
              context,
            ).pop();
          },
        ),

        title: Text(
          l10n.partnerMode,
        ),
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,

            children: [
              Text(
                l10n
                    .partnerModeTitle,
                style:
                    const TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight
                          .bold,
                  color:
                      Colors.white,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              _btn(
                l10n
                    .writeScenario,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PartnerWriteScreen(),
                  ),
                ),
              ),

              _btn(
                l10n.readScenario,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PartnerReadScreen(),
                  ),
                ),
              ),

              
              _btn(
                l10n.cloudInbox,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CloudPartnerInboxScreen(),
                  ),
                ),
              ),

              _btn(
                l10n.incomingReactions,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CloudPartnerReactionsScreen(),
                  ),
                ),
              ),  

              

              _btn(
                l10n.communityScenarios,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const CommunityScenariosScreen(),
                  ),
                ),
              ),

              
              _btn(
                l10n
                    .scenarioHistory,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ScenarioRecordListScreen(),
                  ),
                ),
              ),

              _btn(
                l10n.statistics,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StatisticsScreen(),
                  ),
                ),
              ),

              _btn(
                l10n.relationshipJournal,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RelationshipJournalScreen(),
                  ),
                ),
              ),
              _btn(
                l10n.favoriteScenarios,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoriteScenariosScreen(),
                  ),
                ),
              ),

              _btn(
                l10n.settings,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SettingsScreen(),
                  ),
                ),
              ),
              _btn(
                linked
                    ? l10n.connected
                    : l10n.notConnected,
                () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const PartnerLinkScreen(),
                    ),
                  );

                  _loadLink();
                },
                color:
                    linked
                        ? Colors.green
                        : accent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(
    String text,
    VoidCallback onTap, {
    Color color = accent,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),

      child: SizedBox(
        width: 260,
        height: 46,

        child: ElevatedButton(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                color,
          ),

          onPressed: onTap,

          child: Text(text),
        ),
      ),
    );
  }
}