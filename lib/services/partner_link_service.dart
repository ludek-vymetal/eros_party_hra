
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'cloud_partner_service.dart';

class PartnerLinkService {
  PartnerLinkService._();

  static const _keyMyCode = 'my_partner_code';
  static const _keyMyCodeUid = 'my_partner_code_uid';

  static const _keyPartnerCode = 'partner_code';
  static const _keyPartnerUid = 'partner_uid';

  // Dočasně kvůli kompatibilitě se starším systémem.
  static const _keyRelationshipId = 'relationship_id';

  // ==========================================================
  // VLASTNÍ PARTNERSKÝ KÓD
  // ==========================================================

  /// Vrátí trvalý kód aktuálně přihlášeného uživatele.
  ///
  /// Skutečným zdrojem pravdy je CloudPartnerService.
  ///
  /// Kód je uložen v:
  ///
  /// partner_links/{code}
  ///
  /// a současně:
  ///
  /// users/{uid}.myCode
  ///
  /// SharedPreferences zde používáme pouze jako lokální cache.
  static Future<String?> getOrCreateMyCode() async {
    final code =
        await CloudPartnerService.getOrCreateMyCode(
      _generateCode,
    );

    if (code == null) {
      return null;
    }

    final prefs =
        await SharedPreferences.getInstance();

    // Lokální cache vlastního kódu.
    await prefs.setString(
      _keyMyCode,
      code,
    );

    return code;
  }

  // ==========================================================
  // PARTNER CODE
  // ==========================================================

  /// Uloží zadaný partnerský kód pouze lokálně.
  ///
  /// Samotné propojení je řízené RelationshipService.
  static Future<void> savePartnerCode(
    String code,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _keyPartnerCode,
      code,
    );
  }

  // ==========================================================
  // PARTNER UID
  // ==========================================================

  /// Uloží UID partnera jako lokální cache.
  static Future<void> savePartnerUid(
    String uid,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _keyPartnerUid,
      uid,
    );
  }

  /// Vrátí lokálně uložené UID partnera.
  ///
  /// Pro skutečné získání partnera používej
  /// RelationshipService.getPartnerUid().
  static Future<String?> getPartnerUid() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      _keyPartnerUid,
    );
  }

  // ==========================================================
  // LINK STATUS
  // ==========================================================

  /// Vrátí true, pokud je lokálně uložen partnerský kód.
  ///
  /// Tento údaj je pouze kompatibilní cache.
  /// Skutečný stav Relationship určuje RelationshipService.
  static Future<bool> isLinked() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.containsKey(
      _keyPartnerCode,
    );
  }

  // ==========================================================
  // UNLINK
  // ==========================================================

  /// Odpojí lokálního partnera.
  ///
  /// Vlastní partnerský kód se NEMAŽE.
  static Future<void> unlink() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _keyPartnerCode,
    );

    await prefs.remove(
      _keyPartnerUid,
    );

    // Dočasně kvůli kompatibilitě.
    await prefs.remove(
      _keyRelationshipId,
    );
  }

  // ==========================================================
  // RESET VLASTNÍHO KÓDU
  // ==========================================================

  /// Smaže pouze lokální cache vlastního kódu.
  ///
  /// Skutečný Firebase kód nemažeme.
  /// Trvalý kód uživatele spravuje CloudPartnerService.
  static Future<void> resetMyCode() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _keyMyCode,
    );

    await prefs.remove(
      _keyMyCodeUid,
    );
  }

  // ==========================================================
  // LOGOUT
  // ==========================================================

  /// Vyčistí lokální údaje o partnerovi.
  ///
  /// Vlastní partnerský kód zůstává zachován.
  static Future<void> clearForLogout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _keyPartnerCode,
    );

    await prefs.remove(
      _keyPartnerUid,
    );

    await prefs.remove(
      _keyRelationshipId,
    );

    // Vlastní kód NEMAŽEME.
  }

  // ==========================================================
  // RELATIONSHIP MIGRATION
  // ==========================================================

  /// Dočasně ponecháno kvůli starším částem aplikace.
  static Future<void> saveRelationshipId(
    String relationshipId,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _keyRelationshipId,
      relationshipId,
    );
  }

  /// Dočasně ponecháno kvůli starším částem aplikace.
  static Future<String?> getRelationshipId() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      _keyRelationshipId,
    );
  }

  // ==========================================================
  // GENERÁTOR KÓDU
  // ==========================================================

  /// Generátor používaný CloudPartnerService.
  static String _generateCode() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final random =
        Random.secure();

    return List.generate(
      6,
      (_) => chars[
          random.nextInt(chars.length)],
    ).join();
  }
}