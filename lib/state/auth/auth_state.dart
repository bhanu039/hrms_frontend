import '../models/user_session.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserSession? session;
  final String? message;

  const AuthState({
    this.status = AuthStatus.initial,
    this.session,
    this.message,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserSession? session,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      message: message,
    );
  }
}