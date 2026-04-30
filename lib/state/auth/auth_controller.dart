import 'package:dio/dio.dart';
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

  Future<UserSession?> _loadSessionFromStorage() async {
    final isExpired = await SessionService.isTokenExpired();
    if (isExpired) return null;

    final token = await SessionService.getToken();
    final id = await SessionService.getID();
    final role = await SessionService.getRole();
    final email = await SessionService.getEmail();
    final name = await SessionService.getName();

    if (token == null || token.isEmpty) return null;

    return UserSession.fromStorage(
      token: token,
      id: id ?? "",
      role: role ?? "",
      name: name ?? "",
      email: email ?? "",
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await ApiService.login(email: email, password: password);
      final ok = response.statusCode == 200 && response.data["success"] == true;

      if (!ok) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: response.data["message"]?.toString() ?? "Invalid credentials",
        );
      }

      final session = UserSession.fromLoginResponse(
        Map<String, dynamic>.from(response.data as Map),
      );

      await SessionService.saveSession(
        token: session.token,
        user: {
          "id": session.id,
          "role": session.role,
          "name": session.name,
          "email": session.email,
        },
      );

      return session;
    });
  }

  Future<void> logout() async {
    await SessionService.clearSession();
    state = const AsyncData(null);
  }

  Future<void> updateLocalProfile({
    required String name,
    required String email,
  }) async {
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
      },
    );
    state = AsyncData(updated);
  }
}

