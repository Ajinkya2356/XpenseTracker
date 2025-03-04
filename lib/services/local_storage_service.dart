import 'dart:convert';
import 'package:shared_preferences.dart';

class LocalStorageService {
  static const String userProfileKey = 'user_profile';
  static const String userSettingsKey = 'user_settings';
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // User Profile Methods
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await _prefs.setString(userProfileKey, jsonEncode(profile));
  }

  Map<String, dynamic>? getUserProfile() {
    final String? profileStr = _prefs.getString(userProfileKey);
    if (profileStr == null) return null;
    return jsonDecode(profileStr) as Map<String, dynamic>;
  }

  // User Settings Methods
  Future<void> saveUserSettings(Map<String, dynamic> settings) async {
    await _prefs.setString(userSettingsKey, jsonEncode(settings));
  }

  Map<String, dynamic>? getUserSettings() {
    final String? settingsStr = _prefs.getString(userSettingsKey);
    if (settingsStr == null) return null;
    return jsonDecode(settingsStr) as Map<String, dynamic>;
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
