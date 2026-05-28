import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskRepository {
  static const _storageKey = 'party_tasks';

  /// =========================
  /// NAČTENÍ VŠECH ÚKOLŮ
  /// =========================
  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> data = jsonDecode(jsonString);
      return data.map((e) => Task.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  /// =========================
  /// ULOŽENÍ VŠECH ÚKOLŮ
  /// =========================
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  /// =========================
  /// PŘIDAT ÚKOL
  /// =========================
  static Future<void> addTask(Task task) async {
    final tasks = await loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  /// =========================
  /// UPRAVIT ÚKOL
  /// =========================
  static Future<void> updateTask(Task updated) async {
    final tasks = await loadTasks();

    final index = tasks.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;

    tasks[index] = updated;
    await saveTasks(tasks);
  }

  /// =========================
  /// SMAZAT ÚKOL
  /// =========================
  static Future<void> deleteTask(String taskId) async {
    final tasks = await loadTasks();
    tasks.removeWhere((t) => t.id == taskId);
    await saveTasks(tasks);
  }

  /// =========================
  /// IMPORT Z QR (PŘIDÁ)
  /// =========================
  static Future<void> importFromQr(String qrString) async {
    final task = Task.fromQrString(qrString);
    await addTask(task);
  }

  /// =========================
  /// EXPORT DO QR
  /// =========================
  static String exportToQr(Task task) {
    return task.toQrString();
  }

  /// =========================
  /// VYMAZAT VŠECHNO (RESET)
  /// =========================
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
