import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_state.dart';

class PartyGamePersistence {
  static const _storageKey = 'party_game_state';

  /// Uloží rozehranou party hru
  static Future<void> save(PartyGameState state) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.toJson());
    await prefs.setString(_storageKey, jsonString);
  }

  /// Načte rozehranou party hru
  /// Vrátí null, pokud žádná neexistuje
  static Future<PartyGameState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> json =
          jsonDecode(jsonString) as Map<String, dynamic>;
      return PartyGameState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Smaže uloženou party hru
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  /// Zjistí, zda existuje uložená hra
  static Future<bool> hasSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_storageKey);
  }
}
