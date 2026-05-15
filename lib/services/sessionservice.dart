import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SessionService {
  // 🔐 Secure Storage Instance
  static const _storage = FlutterSecureStorage();

  // 🔐 SAVE TOKEN + USER DATA
  static Future<void> saveSession({
    required String token,
    required Map user,
  }) async {
    print(
      "Saving session for user: ${user["email"]}, token: $token"
      "its a session with token: $token, user: ${user["email"]}",
    );
    await _storage.write(key: "token", value: token);
    await _storage.write(key: "role", value: user["role"] ?? "");
    await _storage.write(key: "id", value: user["id"] ?? "");
    await _storage.write(key: "email", value: user["email"] ?? "");
    await _storage.write(key: "name", value: user["name"] ?? "");
    await _storage.write(
      key: "companyid",
      value: user["companyId"] ?? "",
    ); // 🔥 store companyid if available
  }

  // 📥 GET TOKEN
  static Future<String?> getToken() async {
    final token = await _storage.read(key: "token");
    print("Retrieving token from storage: $token");
    return token;
  }

  // 📥 GET ID
  static Future<String?> getID() async {
    return await _storage.read(key: "id");
  }

  // 📥 GET ROLE
  static Future<String?> getRole() async {
    return await _storage.read(key: "role");
  }

  // 📥 GET EMAIL
  static Future<String?> getEmail() async {
    return await _storage.read(key: "email");
  }

  // 📥 GET NAME
  static Future<String?> getName() async {
    return await _storage.read(key: "name");
  }

  static Future<String?> getCompanyID() async {
    return await _storage.read(key: "companyid");
  }

  // ❌ CLEAR ONLY TOKEN
  static Future<void> clearToken() async {
    await _storage.delete(key: "token");
  }

  // 🔥 CHECK TOKEN EXPIRY
  static Future<bool> isTokenExpired() async {
    final token = await getToken();

    if (token == null || token.isEmpty) return true;

    final isExpired = JwtDecoder.isExpired(token);

    if (isExpired) {
      await clearSession(); // 🔥 remove full session
    }

    return isExpired;
  }

  // 🧹 CLEAR FULL SESSION
  static Future<void> clearSession() async {
    await _storage.deleteAll();
  }
}
