import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scenar.dart';

class ScenarioStorage {
  static const _key = 'scenarios';

  // =========================
  // 📥 LOAD ALL
  // =========================
  static Future<List<Scenar>> loadScenarios() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List;
    return list.map((e) => Scenar.fromJson(e)).toList();
  }

  // =========================
  // 💾 SAVE ALL
  // =========================
  static Future<void> saveScenarios(List<Scenar> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  // =========================
  // ➕ ADD
  // =========================
  static Future<void> addScenario(Scenar scenar) async {
    final all = await loadScenarios();
    all.add(scenar);
    await saveScenarios(all);
  }

  // =========================
  // 🔎 GET BY ID  ⭐ KLÍČOVÉ
  // =========================
  static Future<Scenar?> getById(String id) async {
    final all = await loadScenarios();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  // =========================
  // ✏️ UPDATE
  // =========================
  static Future<void> updateScenario(Scenar scenar) async {
    final all = await loadScenarios();
    final index = all.indexWhere((s) => s.id == scenar.id);
    if (index == -1) return;

    all[index] = scenar;
    await saveScenarios(all);
  }

  // =========================
  // 🗑️ DELETE
  // =========================
  static Future<void> deleteScenario(String id) async {
    final all = await loadScenarios();
    all.removeWhere((s) => s.id == id);
    await saveScenarios(all);
  }
}
