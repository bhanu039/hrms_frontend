import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'package:goexperts/main_tabs_screen.dart';
import 'package:goexperts/widgets/top_message.dart';

import 'login_screen.dart';
import 'services/api_service.dart';
import 'services/set_pass_token.dart';
import 'state/auth/auth_bloc.dart';
import 'state/auth/auth_status.dart';
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
  final AppLinks _deepLinkService = AppLinks();
  StreamSubscription<Uri?>? _linkSub;
  @override
  void initState() {
    super.initState();
    ApiService.wakeUpServer();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);

    startFlow(); // ✅ single entry point
  }

  Future<void> startFlow() async {
    final state = context.read<AuthBloc>().state;
    if (state.status == AuthStatus.authenticated) {
      await checkLogin(); // ✅ if already authenticated, skip deep link
      return;
    }

    try {
      final uri = await _deepLinkService.getInitialLink();

      if (uri != null) {
        handleLink(uri);
        return; // ✅ STOP here if deep link exists
      }

      // If no deep link → continue normal flow
      await checkLogin();

      // Listen for future links
      _linkSub = _deepLinkService.uriLinkStream.listen((uri) {
        handleLink(uri);
      });
    } catch (e) {
      print("Deep link error: $e");
      await checkLogin(); // fallback
    }
  }

  void handleLink(Uri uri) async {
    if (_navigated) return;

    print('Received link: $uri');
    print('Host: ${uri.host}');
    print('Path: ${uri.path}');
    print('Params: ${uri.queryParameters}');

    if (uri.path == '/setup-password') {
      final token = uri.queryParameters["token"];

      if (token == null) {
        print('Token missing');
        return;
      }
      // ✅ CHECK IF ALREADY USED
      final isUsed = await DeepLinkService.isTokenUsed(token);

      if (isUsed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
        // ❌ STOP
      }

      _navigated = true;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SetPasswordScreen(token: token)),
      );
    } else {
      print('Unknown deep link: $uri');
    }
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted || _navigated) return; // 🚨 important

    final state = context.read<AuthBloc>().state;
    final session = state.session;

    _navigated = true;

    if (state.status != AuthStatus.authenticated || session == null) {
      TopMessage.show(
        context,
        "Please log in to continue.",
        color: Colors.blue,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }
    else{

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainTabScreen()),
      );
    
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    _linkSub?.cancel(); // ✅ prevent memory leak
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
