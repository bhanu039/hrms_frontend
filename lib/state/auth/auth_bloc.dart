// lib/auth/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/sessionservice.dart';
import '../models/user_session.dart';
import 'auth_controller.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'auth_status.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogout);
    on<UpdateSession>(_onUpdateSession);
  }

  /// 🔥 APP START CHECK
  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    try {
      /// get token
      final token = await _getTokenFromStorage();

      /// no token
      if (token == null || token.isEmpty) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearSession: true,
          ),
        );
        return;
      }

      /// get saved session
      final session = await _getSessionFromStorage();

      if (session == null) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearSession: true,
          ),
        );
        return;
      }

      /// success
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          message: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: e.toString().replaceFirst("Exception: ", ""),
          clearSession: true,
        ),
      );
    }
  }

  /// 🔐 LOGIN
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    try {
      print("AuthBloc Login Attempt => ${event.email}");

      final session = await AuthController().login(
        email: event.email,
        password: event.password,
      );

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          session: session,
          message: "Login successful",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: e.toString().replaceFirst("Exception: ", ""),
          clearSession: true,
        ),
      );
    }
  }

  /// 🚪 LOGOUT
  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      /// clear global session
      currentUserSession = null;

      /// clear storage
      await SessionService.clearSession();

      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearSession: true,
          message: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          message: e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  /// 🔄 UPDATE SESSION
  void _onUpdateSession(UpdateSession event, Emitter<AuthState> emit) {
    emit(state.copyWith(session: event.session));
  }

  /// ================= STORAGE =================

  Future<String?> _getTokenFromStorage() async {
    return await SessionService.getToken();
  }

  Future<UserSession?> _getSessionFromStorage() async {
    final isExpired = await SessionService.isTokenExpired();

    if (isExpired) {
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
      name: name ?? "",
      email: email ?? "",
      role: role ?? "",
      createdAt: "",
      companyid: companyid ?? "",
    );
  }
}
