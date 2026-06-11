import 'package:shared_preferences/shared_preferences.dart';

class DeepLinkService {
  static Future<bool> isTokenUsed(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("used_token") == token;
  }

  static Future<void> markTokenUsed(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("used_token", token);
  }
}