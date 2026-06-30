import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../models/scenario_record.dart';
import '../services/scenario_record_storage.dart';
import 'scenario_record_detail_screen.dart';

class FavoriteScenariosScreen extends StatelessWidget {
  const FavoriteScenariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF12080c),
      appBar: AppBar(
        title: Text(l10n.favoriteScenarios),
        backgroundColor: const Color(0xFF12080c),
      ),
      body: FutureBuilder<List<ScenarioRecord>>(
        future: ScenarioRecordStorage.getAll(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favorites = snapshot.data!
              .where((r) => r.favorite)
              .toList();

          if (favorites.isEmpty) {
            return Center(
              child: Text(
                l10n.favoriteScenariosEmpty,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            );
          }

          favorites.sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
          );

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final record = favorites[index];

              return Card(
                color: const Color(0xFF1f0d14),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  title: Text(
                    record.scenar.nazev,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${record.createdAt.day}.${record.createdAt.month}.${record.createdAt.year}',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white54,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScenarioRecordDetailScreen(
                          record: record,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}