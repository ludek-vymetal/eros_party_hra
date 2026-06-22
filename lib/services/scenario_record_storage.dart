import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scenario_record.dart';
import '../models/reaction.dart';
import 'package:flutter/foundation.dart';

class ScenarioRecordStorage {
  static const _key = 'scenario_records';

  // =========================
  // 📥 LOAD
  // =========================
  static Future<List<ScenarioRecord>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) return [];

    final decoded = jsonDecode(raw) as List;

    final list = decoded
        .map((e) => ScenarioRecord.fromJson(
              Map<String, dynamic>.from(e),
            ))
        .toList();

    for (final r in list) {
      debugPrint(
        'ID=${r.id}  PARENT=${r.parentScenarioId}',
      );
    }

    return list;
    }

  // =========================
  // 💾 SAVE
  // =========================
  static Future<void> save(List<ScenarioRecord> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  // =========================
  // ➕ ADD RECORD
  // =========================
  static Future<void> add(
    ScenarioRecord record,
  ) async {
    final all = await load();

    final exists = all.any(
      (r) => r.id == record.id,
    );

    if (!exists) {
      all.add(record);
      await save(all);
    }
  }

  // =========================
  // ✏️ UPDATE RECORD
  // =========================
  static Future<void> update(ScenarioRecord record) async {
    final all = await load();
    final index = all.indexWhere((r) => r.id == record.id);
    if (index == -1) return;

    all[index] = record;
    await save(all);
  }

  // =========================
// 🗑️ DELETE RECORD
// =========================
static Future<void> delete(String parentId) async {
  final all = await load();

  debugPrint('Mažu parentId = $parentId');

  for (final r in all) {
    debugPrint(
      'ID=${r.id}  PARENT=${r.parentScenarioId}',
    );
  }

  all.removeWhere(
    (r) => r.parentScenarioId == parentId,
  );

  debugPrint('Po: ${all.length}');

  await save(all);

  debugPrint('Uloženo');
}
  // =========================
  // ➕ ADD REACTION
  // =========================
  static Future<void> addReaction(
    String recordId,
    Reaction reaction,
  ) async {
    final all = await load();

    final index = all.indexWhere(
    (r) => r.id == recordId,
  );

    if (index == -1) return;

    final record = all[index];

    final exists = record.reactions.any(
      (r) =>
          r.remoteId != null &&
          r.remoteId == reaction.remoteId,
    );

    if (exists) {
      return;
    }

    all[index] = record.copyWith(
      reactions: [...record.reactions, reaction],
    );

    await save(all);
  }

  // =========================
  // 🔎 GET BY ID
  // =========================
  static Future<ScenarioRecord?> getById(
    String id,
  ) async {
    final all = await load();

    try {
      return all.firstWhere(
        (r) =>
            r.id == id ||
            r.parentScenarioId == id,
      );
    } catch (_) {
      return null;
    }
  }
}
