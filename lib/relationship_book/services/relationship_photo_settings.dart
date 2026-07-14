import 'package:shared_preferences/shared_preferences.dart';

class RelationshipPhotoSettings {
  static const _cloudKey =
      'relationship_photo_cloud_enabled';

  Future<bool> isCloudEnabled() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_cloudKey) ?? true;
  }

  Future<void> setCloudEnabled(
    bool enabled,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _cloudKey,
      enabled,
    );
  }
}
