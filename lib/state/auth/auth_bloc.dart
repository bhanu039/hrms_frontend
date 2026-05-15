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

  String? get createdAt => null;

  /// 🔥 APP START CHECK
  void _onAppStarted(AuthAppStarted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      /// TODO: load from storage (SharedPreferences / SecureStorage)
      final token = await _getTokenFromStorage();

      if (token == null || token.isEmpty) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
        return;
      }

      final session = await _getSessionFromStorage();
      if (session == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
        return;
      }

      emit(state.copyWith(status: AuthStatus.authenticated, session: session));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, message: e.toString()));
    }
  }

  void _onLoginRequested(
  AuthLoginRequested event,
  Emitter<AuthState> emit,
) async {

  emit(
    state.copyWith(
      status: AuthStatus.loading,
    ),
  );

  try {
    print("this block is a auth block, attempting login for user: ${event.email}");

    final session =
        await AuthController().login(
      email: event.email,
      password: event.password,
    );

    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        session: session,
      ),
    );

  } catch (e) {

    emit(
      state.copyWith1(
        status: AuthStatus.error,
        message: e.toString(),
        clearSession: true,
      ),
    );
  }
}

  void _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(state.copyWith(status: AuthStatus.unauthenticated, session: null));
  }

  void _onUpdateSession(UpdateSession event, Emitter<AuthState> emit) {
    emit(state.copyWith(session: event.session));
  }

  /// MOCK STORAGE (replace with SharedPreferences)
  Future<String?> _getTokenFromStorage() async {
    return SessionService.getToken();
  }

  Future<UserSession?> _getSessionFromStorage() async {
    final isExpired = await SessionService.isTokenExpired();
    if (isExpired) return null;

    final token = await SessionService.getToken();
    final id = await SessionService.getID();
    final role = await SessionService.getRole();
    final email = await SessionService.getEmail();
    final name = await SessionService.getName();
      final companyid = await SessionService.getCompanyID();

    if (token == null || token.isEmpty) return null;

    return UserSession.fromStorage(
      token: token,
      id: id ?? "",
      name: name ?? "",
      email: email ?? "",
      role: role ?? "",
      createdAt: createdAt ?? '',
      companyid: companyid ?? "",
    );
  }
}
