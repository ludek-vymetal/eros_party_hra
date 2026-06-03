import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class PartnerLinkService {
  static const _keyMyCode = 'my_partner_code';
  static const _keyPartnerCode = 'partner_code';
  static const _keyPartnerUid = 'partner_uid';

  /// vygeneruje nebo vrátí existující kód
  static Future<String> getOrCreateMyCode() async {
    final prefs =
        await SharedPreferences.getInstance();

    final existing =
        prefs.getString(_keyMyCode);

    if (existing != null) {
      return existing;
    }

    final newCode =
        _generateCode();

    await prefs.setString(
      _keyMyCode,
      newCode,
    );

    return newCode;
  }

  /// uloží kód partnera
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

  /// uloží UID partnera
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

  /// vrátí UID partnera
  static Future<String?> getPartnerUid()
      async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      _keyPartnerUid,
    );
  }

  /// zjištění, zda jsme propojeni
  static Future<bool> isLinked() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.containsKey(
      _keyPartnerCode,
    );
  }

  /// odpojení
  static Future<void> unlink() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _keyPartnerCode,
    );

    await prefs.remove(
      _keyPartnerUid,
    );
  }

  /// smaže vlastní kód
  static Future<void> resetMyCode() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _keyMyCode,
    );
  }

  static String _generateCode() {
    const chars =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final rand = Random.secure();

    return List.generate(
      6,
      (_) => chars[
          rand.nextInt(chars.length)],
    ).join();
  }
}