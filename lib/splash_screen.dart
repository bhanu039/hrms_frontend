import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_links/uni_links.dart';

import 'admin/dashboard_screen.dart';
import 'company/Screens/c_dashboard_screen.dart';
import 'login_screen.dart';
import 'services/api_service.dart';
import 'state/bloc/auth/auth_bloc.dart';
import 'widgets/set_password_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    ApiService.wakeUpServer();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);

    checkLogin();
    initDeepLink();
  }

  void initDeepLink() async {
    final link = await getInitialLink();

    if (link != null) {
      handleLink(link);
    }

    linkStream.listen((link) {
      if (link != null) {
        handleLink(link);
      }
    });
  }

  void handleLink(String link) {
    final uri = Uri.parse(link);

    if (uri.path == '/setup-account') {
      final token = uri.queryParameters['token'];

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SetPasswordScreen(token: token!)),
      );
    }
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted || _navigated) return;

    final state = context.read<AuthBloc>().state;
    final session = state.session;

    if (state.status != AuthStatus.authenticated || session == null) {
      _navigated = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    _navigated = true;
    if (session.isSuperAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (session.isCompanyLikeRole) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CDashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
                colors: [Colors.blue.shade200, Colors.purple.shade300],
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
                      height: 110,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.blue, Colors.purple],
                    ).createShader(bounds),
                    child: const Text(
                      'GoExperts',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Text(
                    'working with you for you',
                    style: TextStyle(fontSize: 5, color: Colors.white70),
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
