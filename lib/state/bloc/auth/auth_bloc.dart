import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../../services/api_service.dart';
import '../../../services/sessionservice.dart';
import '../../models/user_session.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthAppStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthProfileUpdatedLocally extends AuthEvent {
  AuthProfileUpdatedLocally({required this.name, required this.email});

  final String name;
  final String email;
}

enum AuthStatus { initial, loading, authenticated, unauthenticated, failure }

class AuthState {
  const AuthState({required this.status, this.session, this.errorMessage});

  final AuthStatus status;
  final UserSession? session;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    UserSession? session,
    String? errorMessage,
    bool clearSession = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      errorMessage: errorMessage,
    );
  }

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState.initial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthProfileUpdatedLocally>(_onProfileUpdatedLocally);
  }

  Future<void> _onAppStarted(
    AuthAppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final isExpired = await SessionService.isTokenExpired();
    if (isExpired) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }

    final token = await SessionService.getToken();
    final id = await SessionService.getID();
    final role = await SessionService.getRole();
    final email = await SessionService.getEmail();
    final name = await SessionService.getName();

    if (token == null || token.isEmpty) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }

    final session = UserSession.fromStorage(
      token: token,
      id: id ?? '',
      role: role ?? '',
      name: name ?? '',
      email: email ?? '',
    );

    emit(AuthState(status: AuthStatus.authenticated, session: session));
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    try {
      final response = await ApiService.login(
        email: event.email,
        password: event.password,
      );

      final ok = response.statusCode == 200 && response.data['success'] == true;
      if (!ok) {
        throw DioException(
          requestOptions: response.requestOptions,
          message:
              response.data['message']?.toString() ?? 'Invalid credentials',
        );
      }

      final session = UserSession.fromLoginResponse(
        Map<String, dynamic>.from(response.data as Map),
      );

      await SessionService.saveSession(
        token: session.token,
        user: {
          'id': session.id,
          'role': session.role,
          'name': session.name,
          'email': session.email,
        },
      );

      emit(AuthState(status: AuthStatus.authenticated, session: session));
    } catch (e) {
      final message = e is DioException
          ? (e.message ?? 'Login failed')
          : 'Something went wrong';
      emit(AuthState(status: AuthStatus.failure, errorMessage: message));
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
        clearSession: true,
      ),
    );
    await SessionService.clearSession();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onProfileUpdatedLocally(
    AuthProfileUpdatedLocally event,
    Emitter<AuthState> emit,
  ) async {
    final current = state.session;
    if (current == null) return;

    final updated = current.copyWith(name: event.name, email: event.email);
    await SessionService.saveSession(
      token: updated.token,
      user: {
        'id': updated.id,
        'role': updated.role,
        'name': updated.name,
        'email': updated.email,
      },
    );

    emit(AuthState(status: AuthStatus.authenticated, session: updated));
  }
}
