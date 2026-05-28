import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/partner_scenario.dart';

class PartnerScenarioStorage {
  static const _key = 'partner_scenarios';

  // =========================
  // 📥 LOAD
  // =========================
  static Future<List<PartnerScenario>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    return list.map((e) => PartnerScenario.fromJson(e)).toList();
  }

  // =========================
  // 💾 SAVE ALL
  // =========================
  static Future<void> save(List<PartnerScenario> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  // =========================
  // ➕ ADD
  // =========================
  static Future<void> add(PartnerScenario scenario) async {
    final all = await load();
    all.add(scenario);
    await save(all);
  }

  // =========================
  // ✏️ UPDATE
  // =========================
  static Future<void> update(PartnerScenario scenario) async {
    final all = await load();
    final index = all.indexWhere((s) => s.id == scenario.id);

    if (index == -1) return;

    all[index] = scenario;
    await save(all);
  }

  // =========================
  // 🗑️ DELETE
  // =========================
  static Future<void> delete(String id) async {
    final all = await load();
    all.removeWhere((s) => s.id == id);
    await save(all);
  }

  // =========================
  // 🔎 GET BY ID (DO BUDOUCNA)
  // =========================
  static Future<PartnerScenario?> getById(String id) async {
    final all = await load();
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
