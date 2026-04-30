import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/api_service.dart';
import 'auth_bloc.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState {
  const ProfileState({required this.status, this.message});

  final ProfileStatus status;
  final String? message;

  ProfileState copyWith({ProfileStatus? status, String? message}) {
    return ProfileState(
      status: status ?? this.status,
      message: message,
    );
  }

  factory ProfileState.initial() => const ProfileState(status: ProfileStatus.initial);
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required AuthBloc authBloc})
      : _authBloc = authBloc,
        super(ProfileState.initial());

  final AuthBloc _authBloc;

  Future<void> updateProfile({
    required String name,
    required String email,
    File? image,
  }) async {
    emit(state.copyWith(status: ProfileStatus.loading, message: null));

    try {
      final res = await ApiService.updateProfile(name: name, email: email, image: image);
      if (res['success'] != true) {
        throw Exception(res['message'] ?? 'Failed to update profile');
      }

      _authBloc.add(AuthProfileUpdatedLocally(name: name, email: email));
      emit(state.copyWith(status: ProfileStatus.success, message: 'Profile updated successfully'));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, message: e.toString()));
    }
  }
}
