import 'package:shared_preferences/shared_preferences.dart';

class LocalUserStorage {
  static const String keyUid = "uid";
  static const String keyName = "name";
  static const String keyEmail = "email";
  static const String keyPhoto = "photo";

  // Save user
  static Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
    required String photoUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUid, uid);
    await prefs.setString(keyName, name);
    await prefs.setString(keyEmail, email);
    await prefs.setString(keyPhoto, photoUrl);
  }

  // Load user
  static Future<Map<String, String>?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(keyUid)) return null;

    return {
      "uid": prefs.getString(keyUid) ?? "",
      "name": prefs.getString(keyName) ?? "",
      "email": prefs.getString(keyEmail) ?? "",
      "photo": prefs.getString(keyPhoto) ?? "",
    };
  }

  // Clear user
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUid);
    await prefs.remove(keyName);
    await prefs.remove(keyEmail);
    await prefs.remove(keyPhoto);
  }
}
