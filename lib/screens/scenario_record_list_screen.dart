import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../l10n/app_localizations.dart';
import '../models/scenario_record.dart';
import '../models/scenar.dart';
import '../services/scenario_record_storage.dart';
import 'scenario_record_detail_screen.dart';

class ScenarioRecordListScreen extends StatefulWidget {
  const ScenarioRecordListScreen({super.key});

  @override
  State<ScenarioRecordListScreen> createState() => _ScenarioRecordListScreenState();
}

class _ScenarioRecordListScreenState extends State<ScenarioRecordListScreen> {
  List<ScenarioRecord> records = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) setState(() => loading = false);
      return;
    }

    try {
      // 1. Lokální data
      final localData = await ScenarioRecordStorage.load();

      // 2. Cloud data
      final receivedSnapshot = await FirebaseFirestore.instance
          .collection('partner_scenarios')
          .where('receiverUid', isEqualTo: currentUser.uid)
          .get();

      final sentSnapshot = await FirebaseFirestore.instance
          .collection('partner_scenarios')
          .where('senderUid', isEqualTo: currentUser.uid)
          .get();

      final Map<String, QueryDocumentSnapshot<Map<String, dynamic>>> uniqueDocs = {};

      for (final doc in receivedSnapshot.docs) {
        uniqueDocs[doc.id] = doc;
      }

      for (final doc in sentSnapshot.docs) {
        uniqueDocs[doc.id] = doc;
      }

      final docs = uniqueDocs.values.toList();

      // ... v rámci metody _load, uvnitř cloudData mapování ...
      final cloudData = docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Musíme vytvořit správnou strukturu, aby seděla do modelu
        return ScenarioRecord(
          id: doc.id,
          parentScenarioId: data['parentScenarioId'] ?? doc.id,
          scenar: Scenar(
            id: data['parentScenarioId'] ?? doc.id,
            nazev: data['nazev'] ?? '',
            text: data['text'] ?? '',
            autor: data['autor'] ?? '',
            pro: data['pro'] ?? '',
            cil: data['cil'] ?? '',
            hranice: data['hranice'] ?? '',
            emoce: data['emoce'] is List
                ? List<String>.from(data['emoce'])
                : [],
            ocekavanaReakce: data['ocekavanaReakce'] is List
                ? List<String>.from(data['ocekavanaReakce'])
                : [],
          ),
          // Zde je to důležité: Pokud v databázi nemáš 'reactions' jako list, 
          // musíš tam poslat prázdný list, jinak to spadne
          reactions: [], 
          createdAt: data['createdAt'] is Timestamp 
              ? (data['createdAt'] as Timestamp).toDate() 
              : DateTime.now(),
          senderUid: data['senderUid'] ?? '',
          receiverUid: data['receiverUid'] ?? '',
        );
      }).toList();

      // 3. Spojení a seskupení záznamů
      // 3. Spojení a seskupení záznamů
      final allRecords = [...localData, ...cloudData];

      // nejdřív seřadit od nejnovějších
      allRecords.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      final Map<String, ScenarioRecord> grouped = {};

      for (final record in allRecords) {
        if (!grouped.containsKey(record.parentScenarioId)) {
          grouped[record.parentScenarioId] = record;
        }
      }

      if (!mounted) return;

      setState(() {
        records = grouped.values.toList();
        loading = false;
      });
    } catch (e) {
      debugPrint("Chyba při načítání historie: $e");
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF12080c),
      appBar: AppBar(
        title: Text(l10n.scenarioHistory),
        backgroundColor: const Color(0xFF12080c),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : records.isEmpty
              ? Center(
                  child: Text(
                    l10n.noScenariosYet,
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, i) {
                    final r = records[i];
                    final s = r.scenar;

                              return Card(
            color: const Color(0xFF1f0d14),
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScenarioRecordDetailScreen(record: r),
                  ),
                );
                _load();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      r.reactions.isEmpty
                          ? Icons.mail
                          : r.reactions.last.stav == 'completed'
                              ? Icons.check_circle
                              : r.reactions.last.stav == 'postponed'
                                  ? Icons.schedule
                                  : Icons.cancel,
                      color: r.reactions.isEmpty
                          ? Colors.orange
                          : r.reactions.last.stav == 'completed'
                              ? Colors.green
                              : r.reactions.last.stav == 'postponed'
                                  ? Colors.orange
                                  : Colors.red,
                      size: 32,
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🏷️ ${s.nazev}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            r.senderUid ==
                                    FirebaseAuth.instance.currentUser?.uid
                                ? '📤 Odesláno partnerovi'
                                : '📥 Přijato od partnera',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 4),

                          if (r.reactions.isEmpty)
                            const Text(
                              '📥 Doručeno',
                              style: TextStyle(color: Colors.orange),
                            )
                          else if (r.reactions.last.stav == 'completed')
                            const Text(
                              '✅ Splněno',
                              style: TextStyle(color: Colors.green),
                            )
                          else if (r.reactions.last.stav == 'postponed')
                            const Text(
                              '⏳ Odloženo',
                              style: TextStyle(color: Colors.orange),
                            )
                          else if (r.reactions.last.stav == 'rejected')
                            const Text(
                              '❌ Odmítnuto',
                              style: TextStyle(color: Colors.red),
                            ),

                          const SizedBox(height: 6),

                          Text(
                            '📅 ${r.createdAt.day}.${r.createdAt.month}.${r.createdAt.year}',
                            style: const TextStyle(
                              color: Colors.white54,
                            ),
                          ),

                          if (r.reactions.isNotEmpty &&
                              r.reactions.last.vzkaz != null &&
                              r.reactions.last.vzkaz!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                '💬 ${r.reactions.last.vzkaz}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white38,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}