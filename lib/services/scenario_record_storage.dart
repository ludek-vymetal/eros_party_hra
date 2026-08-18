import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scenario_record.dart';
import '../models/reaction.dart';
import 'relationship_service.dart';

class ScenarioRecordStorage {
  // ==========================================================
  // LEGACY
  // ==========================================================

  /// Starý globální klíč.
  ///
  /// Záměrně ho nemažeme.
  /// Staré záznamy zůstávají v zařízení, ale nový systém
  /// je už nebude používat.
  

  /// Nová verze úložiště.
  ///
  /// Každý účet + Relationship má vlastní prostor.
  static const _keyPrefix = 'scenario_records_v2';

  // ==========================================================
  // CURRENT STORAGE KEY
  // ==========================================================

  /// Vytvoří unikátní SharedPreferences klíč pro aktuálního
  /// uživatele a jeho aktivní Relationship.
  ///
  /// Příklady:
  ///
  /// scenario_records_v2_UID_RELATIONSHIP_ID
  ///
  /// Pokud uživatel zatím nemá Relationship:
  ///
  /// scenario_records_v2_UID_personal
  static Future<String?> _currentKey() async {
    final user = FirebaseAuth.instance.currentUser;

    // Bez přihlášeného uživatele nemáme kam bezpečně ukládat.
    if (user == null) {
      return null;
    }

    final relationshipId =
        await RelationshipService.getActiveRelationshipId();

    final scope =
        relationshipId == null || relationshipId.isEmpty
            ? 'personal'
            : relationshipId;

    return '${_keyPrefix}_${user.uid}_$scope';
  }

  // ==========================================================
  // INTERNAL LOAD
  // ==========================================================

  static Future<List<ScenarioRecord>> _loadFromKey(
    String key,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final raw =
        prefs.getString(key);

    if (raw == null ||
        raw.isEmpty) {
      return [];
    }

    try {
      final decoded =
          jsonDecode(raw);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .map(
            (e) => ScenarioRecord.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    } catch (_) {
      // Pokud by byla data poškozená,
      // aplikace nesmí spadnout.
      return [];
    }
  }

  // ==========================================================
  // INTERNAL SAVE
  // ==========================================================

  static Future<void> _saveToKey(
    String key,
    List<ScenarioRecord> list,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      key,
      jsonEncode(
        list
            .map(
              (e) => e.toJson(),
            )
            .toList(),
      ),
    );
  }

  // ==========================================================
  // LOAD
  // ==========================================================

  /// Načte historii pouze aktuálního uživatele
  /// a jeho aktivního Relationship.
  ///
  /// Starý globální seznam `scenario_records`
  /// se již nepoužívá.
  static Future<List<ScenarioRecord>> load() async {
    final key =
        await _currentKey();

    if (key == null) {
      return [];
    }

    return _loadFromKey(key);
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  static Future<void> save(
    List<ScenarioRecord> list,
  ) async {
    final key =
        await _currentKey();

    if (key == null) {
      return;
    }

    await _saveToKey(
      key,
      list,
    );
  }

  // ==========================================================
  // ADD RECORD
  // ==========================================================

  static Future<void> add(
    ScenarioRecord record,
  ) async {
    final key =
        await _currentKey();

    if (key == null) {
      return;
    }

    final all =
        await _loadFromKey(key);

    final exists = all.any(
      (r) => r.id == record.id,
    );

    if (exists) {
      return;
    }

    all.add(record);

    await _saveToKey(
      key,
      all,
    );
  }

  // ==========================================================
  // UPDATE RECORD
  // ==========================================================

  static Future<void> update(
    ScenarioRecord record,
  ) async {
    final key =
        await _currentKey();

    if (key == null) {
      return;
    }

    final all =
        await _loadFromKey(key);

    final index =
        all.indexWhere(
      (r) => r.id == record.id,
    );

    if (index == -1) {
      return;
    }

    all[index] =
        record;

    await _saveToKey(
      key,
      all,
    );
  }

  // ==========================================================
  // DELETE RECORD
  // ==========================================================

  static Future<void> delete(
    String id,
  ) async {
    final key =
        await _currentKey();

    if (key == null) {
      return;
    }

    final all =
        await _loadFromKey(key);

    all.removeWhere(
      (r) => r.id == id,
    );

    await _saveToKey(
      key,
      all,
    );
  }

  // ==========================================================
  // ADD REACTION
  // ==========================================================

  static Future<void> addReaction(
    String recordId,
    Reaction reaction,
  ) async {
    final key =
        await _currentKey();

    if (key == null) {
      return;
    }

    final all =
        await _loadFromKey(key);

    final index =
        all.indexWhere(
      (r) =>
          r.parentScenarioId ==
          recordId,
    );

    if (index == -1) {
      return;
    }

    final record =
        all[index];

    // Ochrana proti duplicitám
    // z Firebase.
    final exists =
        record.reactions.any(
      (r) =>
          r.remoteId != null &&
          r.remoteId ==
              reaction.remoteId,
    );

    if (exists) {
      return;
    }

    all[index] =
        record.copyWith(
      reactions: [
        ...record.reactions,
        reaction,
      ],
    );

    await _saveToKey(
      key,
      all,
    );
  }

  // ==========================================================
  // GET BY ID
  // ==========================================================

  static Future<ScenarioRecord?> getById(
    String id,
  ) async {
    final all =
        await load();

    try {
      return all.firstWhere(
        (r) =>
            r.id == id ||
            r.parentScenarioId ==
                id,
      );
    } catch (_) {
      return null;
    }
  }

  // ==========================================================
  // GET ALL ATTEMPTS
  // ==========================================================

  static Future<List<ScenarioRecord>>
      getByParentScenarioId(
    String parentScenarioId,
  ) async {
    final all =
        await load();

    final list =
        all
            .where(
              (r) =>
                  r.parentScenarioId ==
                  parentScenarioId,
            )
            .toList();

    list.sort(
      (a, b) =>
          a.createdAt.compareTo(
        b.createdAt,
      ),
    );

    return list;
  }

  // ==========================================================
  // GET ALL RECORDS
  // ==========================================================

  static Future<List<ScenarioRecord>>
      getAll() async {
    return load();
  }
}