import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../core/state/auth/auth_bloc.dart';
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