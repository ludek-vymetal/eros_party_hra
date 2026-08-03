import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class PartnerLinkService {
  PartnerLinkService._();

  static const _keyMyCode = 'my_partner_code';
  static const _keyPartnerCode = 'partner_code';
  static const _keyPartnerUid = 'partner_uid';

  // TODO(MIGRATION):
  // Po dokončení migrace na RelationshipService odstranit.
  static const _keyRelationshipId = 'relationship_id';

  /// Vrátí existující vlastní párovací kód nebo vytvoří nový.
  static Future<String> getOrCreateMyCode() async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getString(_keyMyCode);
    if (existing != null) {
      return existing;
    }

    final newCode = _generateCode();

    await prefs.setString(
      _keyMyCode,
      newCode,
    );

    return newCode;
  }

  /// Uloží partnerský kód.
  static Future<void> savePartnerCode(
    String code,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyPartnerCode,
      code,
    );
  }

  /// Uloží UID partnera.
  static Future<void> savePartnerUid(
    String uid,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyPartnerUid,
      uid,
    );
  }

  /// Vrátí UID partnera.
  static Future<String?> getPartnerUid() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      _keyPartnerUid,
    );
  }

  /// Vrátí true, pokud je partner propojen.
  static Future<bool> isLinked() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(
      _keyPartnerCode,
    );
  }

  /// Odpojí partnera.
  static Future<void> unlink() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyPartnerCode);
    await prefs.remove(_keyPartnerUid);

    // Přechodně kvůli kompatibilitě.
    await prefs.remove(_keyRelationshipId);
  }

  /// Smaže vlastní párovací kód.
  static Future<void> resetMyCode() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(
      _keyMyCode,
    );
  }

  // ==========================================================
  // TEMPORARY MIGRATION
  // Odstranit po kompletním přechodu na RelationshipService.
  // ==========================================================

  static Future<void> saveRelationshipId(
    String relationshipId,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _keyRelationshipId,
      relationshipId,
    );
  }

  static Future<String?> getRelationshipId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(
      _keyRelationshipId,
    );
  }

  // ==========================================================

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final rand = Random.secure();

    return List.generate(
      6,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }
}