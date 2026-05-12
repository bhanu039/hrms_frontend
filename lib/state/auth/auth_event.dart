// lib/auth/auth_event.dart

import '../../services/sessionservice.dart';
import '../models/user_session.dart';

abstract class AuthEvent {}

class LoginSuccess extends AuthEvent {
  final UserSession session;
  LoginSuccess(this.session);
}

class AuthAppStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthLogoutRequested extends AuthEvent {
  AuthLogoutRequested() {
    SessionService.clearSession();
  }
}

class UpdateSession extends AuthEvent {
  final UserSession session;
  UpdateSession(this.session);
}
