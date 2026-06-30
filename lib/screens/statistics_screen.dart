import 'package:flutter/material.dart';

import '../models/scenario_record.dart';
import '../services/scenario_record_storage.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12080c),
      appBar: AppBar(
        title: const Text('📊 Statistiky'),
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

          final records = snapshot.data!;
          final totalReactions = records.fold<int>(
            0,
            (sum, record) => sum + record.reactions.length,
          );

          final accepted = records.fold<int>(
            0,
            (sum, record) =>
                sum +
                record.reactions.where((r) => r.stav == 'Splněno').length,
          );

          final rejected = records.fold<int>(
            0,
            (sum, record) =>
                sum +
                record.reactions.where((r) => r.stav != 'Splněno').length,
          );
          final successRate = totalReactions == 0
            ? 0
            : ((accepted / totalReactions) * 100).round();

          

          final emotionCount = <String, int>{};

          for (final record in records) {
            for (final emotion in record.scenar.emoce) {
              emotionCount[emotion] =
                  (emotionCount[emotion] ?? 0) + 1;
            }
          }

        String favoriteEmotion = '-';

        if (emotionCount.isNotEmpty) {
          favoriteEmotion = emotionCount.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key;
        }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _card(
                '📚 Celkem scénářů',
                records.length.toString(),
              ),
              _card(
                '💬 Celkem reakcí',
                totalReactions.toString(),
              ),
              _card(
                '✅ Přijaté reakce',
                accepted.toString(),
              ),

              _card(
                '❌ Odmítnuté reakce',
                rejected.toString(),
              ),
              _card(
                '📈 Úspěšnost',
                '$successRate %',
              ),
              _card(
                '❤️ Nejčastější emoce',
                favoriteEmotion,
              ),
              
            ],
          );
        },
      ),
    );
  }

  Widget _card(String title, String value) {
    return Card(
      color: const Color(0xFF1f0d14),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
 } 