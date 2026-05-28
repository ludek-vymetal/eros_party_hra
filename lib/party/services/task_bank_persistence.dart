import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'task_bank.dart';
import '../models/player.dart';

class TaskBankPersistence {
  static const _key = 'user_tasks';

  /// Uloží USER úkoly
  static Future<void> save(TaskBank bank) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(bank.toJson()));
  }

  /// Načte USER úkoly a přimíchá je do banky
  static Future<void> loadInto(TaskBank bank) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;

    final Map<String, dynamic> json = jsonDecode(raw);

    for (final g in json.entries) {
      final gender =
          g.key == 'male' ? Gender.male : Gender.female;

      final Map<String, dynamic> diffs =
          g.value as Map<String, dynamic>;

      for (final d in diffs.entries) {
        final diff = int.parse(d.key);
        for (final task in (d.value as List)) {
          bank.addTask(gender, diff, task);
        }
      }
    }
  }
}
