import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api_service.dart';
import '../auth/auth_controller.dart';

final profileControllerProvider =
    AutoDisposeAsyncNotifierProvider<ProfileController, void>(
      ProfileController.new,
    );

class ProfileController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String> updateProfile({
    required String name,
    required String email,
    File? image,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final res = await ApiService.updateProfile(
        name: name,
        email: email,
        image: image,
      );
      if (res["success"] != true) {
        throw Exception(res["message"] ?? "Failed to update profile");
      }

      await ref
          .read(authControllerProvider.notifier)
          .updateLocalProfile(name: name, email: email);
    });

    return "Profile updated successfully";
  }
}

