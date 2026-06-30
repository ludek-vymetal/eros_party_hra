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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _card(
                '📚 Celkem scénářů',
                records.length.toString(),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}