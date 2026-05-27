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
    print("User data being saved: ${user["id"]}");

    await _storage.write(key: "token", value: token);

    await _storage.write(key: "role", value: user["role"]?.toString() ?? "");

    await _storage.write(key: "id", value: user["id"]?.toString() ?? "");

    await _storage.write(key: "email", value: user["email"]?.toString() ?? "");

    await _storage.write(key: "name", value: user["name"]?.toString() ?? "");

    await _storage.write(
      key: "companyid",
      value: user["companyId"]?.toString() ?? "",
    );

    await _storage.write(
      key: "isProfileCompleted",
      value: (user["isProfileCompleted"] ?? false).toString(),
    );
  }

  // 📥 GET TOKEN
  static Future<String?> getToken() async {
    final token = await _storage.read(key: "token");
    print("Retrieving token from storage: $token");
    return token;
  }

  // 📥 GET ID
  static Future<String?> getID() async {
    final id = await _storage.read(key: "id");
    print("Retrieving  ID from storage: $id");

    return id;
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

  static Future<bool> getisProfile() async {
    final value = await _storage.read(key: "isProfileCompleted");

    return value == "true";
  }

  static Future<void> updateProfileStatus(bool value) async {
    await _storage.write(key: "isProfileCompleted", value: value.toString());
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
