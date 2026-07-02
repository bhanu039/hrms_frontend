import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../services/sessionservice.dart';
import '../models/user_session.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
  }

  // ================= SPLASH CHECK =================
  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final token = await SessionService.getToken();

    if (token == null || token.isEmpty) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }

    final session = UserSession(
      token: token,
      id: await SessionService.getID() ?? "",
      role: await SessionService.getRole() ?? "",
      name: await SessionService.getName() ?? "",
      email: await SessionService.getEmail() ?? "",
      isFullRegistered: await SessionService.getisFullRegistered(),
      createdAt: "",
      companyid: await SessionService.getCompanyID() ?? "",
    );

    emit(state.copyWith(status: AuthStatus.authenticated, session: session));
  }

  // ================= LOGIN =================
  Future<void> _onLogin(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final response = await ApiService.login(
        email: event.email,
        password: event.password,
      );
      print("Login response: ${response}");

      final ok = response.statusCode == 200 && response.data["success"] == true;

      if (!ok) {
    print("Login failed with response: ${response.data}");

        emit(
          state.copyWith(
            status: AuthStatus.error,
            message: response.statusMessage ?? response.data["message"] ?? "Login failed",
          ),
        );
        return;
      }
      print("Login response data: ${response.data}");

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
          "createdAt": session.createdAt,
          "companyId": session.companyid,
          "isFullRegistered": session.isFullRegistered,
        },
      );

      emit(state.copyWith(status: AuthStatus.authenticated, session: session));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }

  // ================= LOGOUT =================
  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await SessionService.clearSession();
    currentUserSession = null;
    print("User logged out");
  

    emit(const AuthState(status: AuthStatus.unauthenticated, session: null));
  }
}
