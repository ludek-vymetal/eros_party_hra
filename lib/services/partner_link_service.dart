import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class PartnerLinkService {
  static const _keyMyCode = 'my_partner_code';
  static const _keyPartnerCode = 'partner_code';

  /// vygeneruje nebo vrátí existující kód
  static Future<String> getOrCreateMyCode() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_keyMyCode);
    if (existing != null) return existing;

    final newCode = _generateCode();
    await prefs.setString(_keyMyCode, newCode);
    return newCode;
  }

  /// uloží kód partnera (ruční propojení)
  static Future<void> savePartnerCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPartnerCode, code);
  }

  /// zjištění, zda jsme propojeni
  static Future<bool> isLinked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyPartnerCode);
  }

  /// odpojení
  static Future<void> unlink() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPartnerCode);
  }

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rand = Random.secure();
    return List.generate(
      6,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }
}
