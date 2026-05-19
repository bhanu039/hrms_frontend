// lib/auth/auth_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_service.dart';
import '../../services/sessionservice.dart';
import '../models/user_session.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserSession?>(AuthController.new);

class AuthController extends AsyncNotifier<UserSession?> {
  @override
  Future<UserSession?> build() async {
    return _loadSessionFromStorage();
  }

  /// ================= LOAD SESSION =================

  Future<UserSession?> _loadSessionFromStorage() async {
    try {
      final isExpired = await SessionService.isTokenExpired();

      /// token expired
      if (isExpired) {
        await SessionService.clearSession();
        return null;
      }

      final token = await SessionService.getToken();
      final id = await SessionService.getID();
      final role = await SessionService.getRole();
      final email = await SessionService.getEmail();
      final name = await SessionService.getName();
      final companyid = await SessionService.getCompanyID();

      if (token == null || token.isEmpty) {
        return null;
      }

      return UserSession.fromStorage(
        token: token,
        id: id ?? "",
        role: role ?? "",
        name: name ?? "",
        email: email ?? "",
        createdAt: "",
        companyid: companyid ?? "",
      );
    } catch (e) {
      print("Load Session Error => $e");
      return null;
    }
  }

  /// ================= LOGIN =================

  Future<UserSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.login(email: email, password: password);

      final ok = response.statusCode == 200 && response.data["success"] == true;

      if (!ok) {
        throw Exception(response.data["message"] ?? "Invalid credentials");
      }

      final session = UserSession.fromLoginResponse(
        Map<String, dynamic>.from(response.data as Map),
      );

      print(
        "AuthController Login Success => "
        "${session.email}, ${session.role}",
      );

      /// 🔥 global session
      currentUserSession = session;

      /// 🔥 save session
      await SessionService.saveSession(
        token: session.token,
        user: {
          "id": session.id,
          "role": session.role,
          "name": session.name,
          "email": session.email,
          "createdAt": session.createdAt,
          "companyId": session.companyid,
        },
      );

      /// update riverpod state
      state = AsyncData(session);

      return session;
    } catch (e) {
      print("Login Error => $e");
      rethrow;
    }
  }

  /// ================= LOGOUT =================

  Future<void> logout() async {
    try {
      currentUserSession = null;

      await SessionService.clearSession();

      state = const AsyncData(null);
    } catch (e) {
      print("Logout Error => $e");
    }
  }

  /// ================= UPDATE PROFILE =================

  Future<void> updateLocalProfile({
    required String name,
    required String email,
  }) async {
    try {
      final current = state.valueOrNull;

      if (current == null) return;

      final updated = current.copyWith(name: name, email: email);

      await SessionService.saveSession(
        token: updated.token,
        user: {
          "id": updated.id,
          "role": updated.role,
          "name": updated.name,
          "email": updated.email,
          "createdAt": updated.createdAt,
          "companyId": updated.companyid,
        },
      );

      currentUserSession = updated;

      state = AsyncData(updated);
    } catch (e) {
      print("Update Profile Error => $e");
    }
  }
}
