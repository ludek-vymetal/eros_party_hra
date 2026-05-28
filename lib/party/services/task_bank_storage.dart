import 'package:shared_preferences/shared_preferences.dart';
import 'task_bank.dart';

class TaskBankStorage {
  static const _key = 'task_bank_full';

  static Future<TaskBank?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    return TaskBank.fromJsonString(raw);
  }

  static Future<void> save(TaskBank bank) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, bank.toJsonString());
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
