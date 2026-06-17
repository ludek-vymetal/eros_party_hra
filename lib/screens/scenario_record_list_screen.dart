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
      final snapshot = await FirebaseFirestore.instance
          .collection('partner_scenarios')
          .where('receiverUid', isEqualTo: currentUser.uid)
          .get();

      // ... v rámci metody _load, uvnitř cloudData mapování ...
      final cloudData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        
        // Musíme vytvořit správnou strukturu, aby seděla do modelu
        return ScenarioRecord(
          id: doc.id,
          parentScenarioId: data['parentScenarioId'] ?? doc.id,
          scenar: Scenar(
            id: data['parentScenarioId'] ?? doc.id,
            nazev: data['nazev'] ?? '',
            text: data['text'] ?? '',
            autor: 'Partner',
            pro: 'Já',
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
      final allRecords = [...localData, ...cloudData];
      final Map<String, ScenarioRecord> grouped = {};

      allRecords.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      for (final record in allRecords) {
        if (!grouped.containsKey(record.parentScenarioId)) {
          grouped[record.parentScenarioId] = record;
        }
      }

      // 4. Aktualizace UI
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
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text(
                          s.nazev,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${s.autor} → ${s.pro}\n${r.reactions.length} ${l10n.reactions}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScenarioRecordDetailScreen(record: r),
                            ),
                          );
                          _load();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}