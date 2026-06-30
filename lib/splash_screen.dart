import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/app_constants/app_color.dart';
import 'core/app_constants/app_constants.dart';
import 'core/services/api_service.dart';
import 'core/state/auth/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AuthBloc authBloc;
  
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isProfileCompleted = false;
  @override
  void initState() {
    
    
    authBloc = context.read<AuthBloc>(); 
    ApiService.wakeUpServer();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _navigate();
    super.initState();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 50));

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
      context.go(isFullRegistered! ? '/company/dashboard' : '/company/onboarding');
      return;
    }

    context.go('/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    // _linkSub?.cancel(); // ✅ prevent memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary100, AppColors.secondary100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: _animation.value,
                    child: Container(
                      height: 150,
                      width: 150,

                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppConstants.logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.primary100, AppColors.secondary100],
                    ).createShader(bounds),
                    child: Text(
                      'GoExperts',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const Text(
                    'working with you for you',
                    style: TextStyle(fontSize: 16, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
