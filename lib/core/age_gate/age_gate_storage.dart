import 'package:shared_preferences/shared_preferences.dart';

class AgeGateStorage {
  static const _keyIsAdult = 'is_adult';

  Future<bool> isAdultConfirmed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsAdult) ?? false;
  }

  Future<void> confirmAdult() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsAdult, true);
  }
}
