import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/state/auth/auth_bloc.dart';
import '../../core/state/auth/auth_event.dart';
import '../../core/state/models/user_session.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthBloc authBloc;

  ProfileCubit(this.authBloc)
      : super(ProfileState(status: ProfileStatus.initial));

  Future<void> updateProfile({
    required String name,
    required String email,
    File? image,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final current = authBloc.state.session;

      if (current == null) {
        emit(state.copyWith(
          status: ProfileStatus.failure,
          message: "User not found",
        ));
        return;
      }

      final updatedUser = UserSession(
        token: current.token,
        id: current.id,
        name: name,
        email: email,
        role: current.role,
        isFullRegistered: current.isFullRegistered,
        createdAt: current.createdAt,
      );

      // update session in AuthBloc
      authBloc.add(UpdateSession(updatedUser));

      emit(state.copyWith(
        status: ProfileStatus.success,
        message: "Profile updated successfully",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        message: e.toString(),
      ));
    }
  }
}