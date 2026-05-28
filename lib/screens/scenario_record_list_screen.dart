import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

import '../models/scenario_record.dart';

import '../services/scenario_record_storage.dart';

import 'scenario_record_detail_screen.dart';

class ScenarioRecordListScreen
    extends StatefulWidget {
  const ScenarioRecordListScreen({
    super.key,
  });

  @override
  State<ScenarioRecordListScreen>
      createState() =>
          _ScenarioRecordListScreenState();
}

class _ScenarioRecordListScreenState
    extends State<
        ScenarioRecordListScreen> {
  List<ScenarioRecord>
      records = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<void> _load() async {
    final data =
        await ScenarioRecordStorage
            .load();

    data.sort(
      (a, b) => b.createdAt
          .compareTo(
        a.createdAt,
      ),
    );

    if (!mounted) return;

    setState(() {
      records = data;
      loading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final l10n =
        AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          const Color(
        0xFF12080c,
      ),

      appBar: AppBar(
        title: Text(
          l10n
              .scenarioHistoryTitle,
        ),

        backgroundColor:
            const Color(
          0xFF12080c,
        ),
      ),

      body:
          loading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : records.isEmpty
              ? Center(
                  child: Text(
                    l10n
                        .noScenariosYet,
                    style:
                        const TextStyle(
                      color: Colors
                          .white70,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount:
                      records.length,

                  itemBuilder:
                      (
                        context,
                        i,
                      ) {
                        final r =
                            records[i];

                        final s =
                            r.scenar;

                        return Card(
                          color:
                              const Color(
                            0xFF1f0d14,
                          ),

                          margin:
                              const EdgeInsets.symmetric(
                            horizontal:
                                12,
                            vertical:
                                8,
                          ),

                          child:
                              ListTile(
                            title:
                                Text(
                              s.nazev,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            subtitle:
                                Text(
                              '${s.autor} → ${s.pro}\n'
                              '${r.reactions.length} ${l10n.reactions}',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                              ),
                            ),

                            trailing:
                                const Icon(
                              Icons
                                  .chevron_right,

                              color:
                                  Colors.white54,
                            ),

                            onTap:
                                () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          ScenarioRecordDetailScreen(
                                    record:
                                        r,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                ),
    );
  }
}