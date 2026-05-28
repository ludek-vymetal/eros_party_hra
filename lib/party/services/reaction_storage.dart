import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/reaction.dart';

class ReactionStorage {
  static const String _key = 'reactions';

  // =========================
  // 💾 ULOŽENÍ
  // =========================
  static Future<void> saveReactions(
    List<Reaction> reactions,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final data = reactions
        .map((e) => e.toJson())
        .toList();

    await prefs.setString(
      _key,
      jsonEncode(data),
    );
  }

  // =========================
  // 📂 NAČTENÍ
  // =========================
  static Future<List<Reaction>>
      loadReactions() async {
    final prefs =
        await SharedPreferences.getInstance();

    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded =
          jsonDecode(raw);

      return decoded
          .map(
            (e) => Reaction.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print(
        '❌ ReactionStorage load error: $e',
      );

      return [];
    }
  }

  // =========================
  // ➕ PŘIDÁNÍ REAKCE
  // =========================
  static Future<void> addReaction(
    Reaction reaction,
  ) async {
    final reactions =
        await loadReactions();

    reactions.add(reaction);

    await saveReactions(reactions);
  }

  // =========================
  // 🗑️ SMAZÁNÍ VŠECH
  // =========================
  static Future<void> clear() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}