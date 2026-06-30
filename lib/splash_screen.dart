import 'package:flutter/material.dart';

import 'core/app_constants/app_color.dart';
import 'core/app_constants/app_constants.dart';
import 'core/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
 
  bool isProfileCompleted = false;
  @override
  void initState() {
    super.initState();
    ApiService.wakeUpServer();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(_controller);

    
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
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
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
                          image: AssetImage(AppConstants.logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.primaryColor, AppColors.darkSecondaryColor],
                    ).createShader(bounds),
                    child: const Text(
                      'GoExperts',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  const Text(
                    'working with you for you',
                    style: TextStyle(fontSize: 16, color: AppColors.textSecondaryColor),
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
