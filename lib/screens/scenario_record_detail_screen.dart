import 'package:flutter/material.dart';
import '../models/scenario_record.dart';
import '../services/crypto_service.dart';
import '../services/scenario_record_storage.dart';
import 'partner_write.dart';

class ScenarioRecordDetailScreen extends StatefulWidget {
  final ScenarioRecord record;

  const ScenarioRecordDetailScreen({
    super.key,
    required this.record,
  });

  @override
  State<ScenarioRecordDetailScreen> createState() =>
      _ScenarioRecordDetailScreenState();
}

class _ScenarioRecordDetailScreenState
    extends State<ScenarioRecordDetailScreen> {

  List<ScenarioRecord> historyRecords = [];
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final all = await ScenarioRecordStorage.load();

    historyRecords = all.where(
      (r) => r.parentScenarioId == widget.record.parentScenarioId,
    ).toList();

    historyRecords.sort(
      (a, b) => a.createdAt.compareTo(b.createdAt),
    );

    setState(() {});
  }
  void _resend(BuildContext context) {
    final code = CryptoService.encodeScenar(widget.record.scenar);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Znovu odeslat scénář'),
        content: SelectableText(code),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zavřít'),
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PartnerWriteScreen(
          existingRecord: widget.record,
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Smazat scénář?'),
            content: const Text(
              'Tento scénář i všechny reakce budou trvale odstraněny.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Zrušit'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Smazat'),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    await ScenarioRecordStorage.delete(widget.record.id);

    

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.record.scenar;
    final currentIndex = historyRecords.indexWhere(
      (r) => r.id == widget.record.id,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF12080c),
      appBar: AppBar(
        title: Text(s.nazev),
        backgroundColor: const Color(0xFF12080c),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Znovu odeslat',
            onPressed: () => _resend(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Upravit',
            onPressed: () => _edit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Smazat',
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...historyRecords.asMap().entries.map((entry) {
              final index = entry.key;
              final r = entry.value;
              final s = r.scenar;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'Pokus ${index + 1}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _section('🎯 Cíl', s.cil),
                  _section('📜 Text scénáře', s.text),
                  _section('⚠️ Hranice', s.hranice),

                  if (s.emoce.isNotEmpty)
                    _section('❤️ Emoce', s.emoce.join(', ')),

                  const Divider(color: Colors.white24),

                  const SizedBox(height: 20),
                ],
              );
            }),

            const SizedBox(height: 24),

            const Text(
              '💬 Reakce',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            if (widget.record.reactions.isEmpty)
              const Text(
                'Zatím žádné reakce',
                style: TextStyle(color: Colors.white54),
              )
            else
              ...widget.record.reactions.map((r) {
                return Card(
                  color: const Color(0xFF1f0d14),
                  margin: const EdgeInsets.symmetric(vertical: 6),
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
                        if (r.emoce != null)
                          Text(
                            r.emoce!,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        if (r.vzkaz != null && r.vzkaz!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '💬 ${r.vzkaz}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          r.datumFormatted,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

            const SizedBox(height: 32),

            const Divider(color: Colors.white24),

            const SizedBox(height: 16),

            const Text(
              '🔄 Chcete si tento scénář zopakovat?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Zopakovat scénář'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PartnerWriteScreen(
                        existingRecord: widget.record,
                        repeatScenario: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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