import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SessionService {
  // 🔐 SAVE TOKEN + USER DATA
  static Future<void> saveSession({
    required String token,
    required Map user,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);
    await prefs.setString("role", user["role"] ?? "");
    await prefs.setString("id", user["id"] ?? "");
    await prefs.setString("email", user["email"] ?? "");
    await prefs.setString("name", user["name"] ?? "");
  }

  // 📥 GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
   static Future<String?> getID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("id");
  }

  // 📥 GET ROLE
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  // 📥 GET EMAIL
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  // 📥 GET NAME
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("name");
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  // 🔥 CHECK TOKEN EXPIRY
  static Future<bool> isTokenExpired() async {
    final token = await getToken();

    if (token == null || token.isEmpty) return true;

    final isExpired = JwtDecoder.isExpired(token);

    if (isExpired) {
      await clearToken(); // 🔥 remove expired token automatically
    }

    return isExpired;
  }

  // 🧹 CLEAR SESSION
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
