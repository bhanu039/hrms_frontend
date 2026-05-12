// lib/auth/auth_state.dart

import '../models/user_session.dart';
import 'auth_status.dart';

class AuthState {
  final AuthStatus status;
  final UserSession? session;
  final String? message;

  AuthState({this.status = AuthStatus.initial, this.session, this.message});
  factory AuthState.initial() {
    return AuthState(status: AuthStatus.initial, session: null, message: null);
  }

  AuthState copyWith({
    AuthStatus? status,
    UserSession? session,
    String? message,
  }) {
    print(  "Copying AuthState with: status=$status, session=${session?.email}, message=$message");
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      message: message ?? this.message,
    );
  }

  AuthState copyWith1({
    AuthStatus? status,
    UserSession? session,
    String? message,
    bool clearSession = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : (session ?? this.session),
      message: message ?? this.message,
    );
  }
}
