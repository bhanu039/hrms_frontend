import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/app_constants/app_color.dart';
import 'core/app_constants/app_constants.dart';
import 'core/services/api_service.dart';
import 'core/state/auth/auth_bloc.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AuthBloc authBloc;

 late VideoPlayerController _controller;



  bool isProfileCompleted = false;
  @override
  void initState() {
    
      authBloc = context.read<AuthBloc>();

    _controller = VideoPlayerController.asset(
      AppConstants.appVideo1,
    )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying) {
        _goToNextScreen();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final session = authBloc.state.session;

    final role = session?.role;
    final isLoggedIn = session != null;
    final isFullRegistered = session?.isFullRegistered ?? false;

    if (!isLoggedIn) {
      context.go('/login');
      return;
    }

    if (role == "SUPER_ADMIN") {
      context.go('/admin/dashboard');
      return;
    }
    if (role == "HR") {
      context.go(isFullRegistered! ? '/hr/dashboard' : '/hr/onbording');
      return;
    }
    if (role == "EMPLOYEE") {
      context.go(isFullRegistered! ? '/emp/dashboard' : '/emp/onbording');
      return;
    }
    if (role == "OWNER") {
      context.go(
        isFullRegistered! ? '/company/dashboard' : '/company/onboarding',
      );
      return;
    }

    context.go('/login');
  }

 

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width*0.80,
                  height: _controller.value.size.height*0.80,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
