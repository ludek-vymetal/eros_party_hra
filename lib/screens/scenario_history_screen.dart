import 'package:flutter/material.dart';

import '../models/scenario_record.dart';
import '../services/scenario_record_storage.dart';
// Ujisti se, že máš importovaný soubor, kde je definován ScenarioRecordDetailScreen
import 'scenario_record_detail_screen.dart'; 

class ScenarioHistoryScreen extends StatelessWidget {
  final String parentScenarioId;

  const ScenarioHistoryScreen({
    super.key,
    required this.parentScenarioId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12080c),
      appBar: AppBar(
        title: const Text('Historie scénáře'),
        backgroundColor: const Color(0xFF12080c),
      ),
      body: FutureBuilder<List<ScenarioRecord>>(
        future: ScenarioRecordStorage.getByParentScenarioId(
          parentScenarioId,
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final attempts = snapshot.data!;

          if (attempts.isEmpty) {
            return const Center(
              child: Text(
                'Historie je prázdná',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: attempts.length,
            itemBuilder: (context, index) {
              final attempt = attempts[index];
              final s = attempt.scenar;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScenarioRecordDetailScreen(
                        record: attempt,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: const Color(0xFF1f0d14),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📖 Pokus ${index + 1}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${attempt.createdAt.day}.${attempt.createdAt.month}.${attempt.createdAt.year}',
                          style: const TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _section('🎯 Cíl', s.cil),
                        _section('📜 Text scénáře', s.text),
                        _section('⚠️ Hranice', s.hranice),

                        if (s.emoce.isNotEmpty)
                          _section(
                            '❤️ Emoce',
                            s.emoce.join(', '),
                          ),

                        const SizedBox(height: 24),

                        const Text(
                          '💬 Reakce',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (attempt.reactions.isEmpty)
                          const Text(
                            'Žádné reakce',
                            style: TextStyle(
                              color: Colors.white54,
                            ),
                          )
                        else
                          ...attempt.reactions.map(
                            (r) => Card(
                              color: const Color(0xFF2b141c),
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.stav,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (r.vzkaz != null && r.vzkaz!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          r.vzkaz!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 6),
                                    Text(
                                      r.datumFormatted,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                        
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _section(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text.isEmpty ? '—' : text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}