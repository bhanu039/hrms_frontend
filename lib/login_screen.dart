import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/main_tabs_screen.dart';
import 'package:goexperts/widgets/top_message.dart';

import 'state/auth/auth_bloc.dart';
import 'state/auth/auth_event.dart';
import 'state/auth/auth_state.dart';


import 'forgot_password_screen.dart';
import 'services/api_service.dart';
import 'widgets/app_primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool valide = true;

  void login() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      AuthLoginRequested(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
      ),
    );
  }

  void showError(String msg) {
    TopMessage.show(context, msg, color: Colors.red);
  }

  @override
  void initState() {
    super.initState();

    ApiService.wakeUpServer();
  }

  @override
  void dispose() {
    // ✅ cancel the subscription
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        
        final session = state.session;

        print(
          "Auth State Changed: ${state.status}, "
          "Session: ${session?.email}, "
          "Role: ${session?.role}",
        );

        if (state.status == AuthStatus.error) {
          showError(state.message ?? 'Invalid credentials');
          return;
        }if(state.status == AuthStatus.authenticated) {
          print("Navigating to MainTabScreen");

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainTabScreen()),
            (route) => false,
          );
        }else{

        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xff07111f), 
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 820;

            return Stack(
              children: [
                const Positioned.fill(child: _LoginBackground()),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1040),
                        child: isWide
                            ? Row(
                                children: [
                                  const Expanded(child: _ThreeDBrandPanel()),
                                  const SizedBox(width: 34),
                                  Expanded(
                                    child: _ThreeDLoginPanel(state: this),
                                  ),
                                ],
                              )
                            : _ThreeDLoginPanel(state: this),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bgimage.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff07111f).withValues(alpha: 0.82),
            ),
          ),
        ),
        Positioned(
          left: -80,
          top: 80,
          child: _DepthPlate(
            width: 260,
            height: 160,
            color: const Color(0xff22d3ee).withValues(alpha: 0.16),
            rotation: -0.22,
          ),
        ),
        Positioned(
          right: -70,
          bottom: 40,
          child: _DepthPlate(
            width: 310,
            height: 180,
            color: const Color(0xfff59e0b).withValues(alpha: 0.14),
            rotation: 0.18,
          ),
        ),
        const Positioned(right: 120, top: 90, child: _FloatingCube(size: 82)),
        const Positioned(
          left: 90,
          bottom: 110,
          child: _FloatingCube(size: 58, rotation: -0.32),
        ),
      ],
    );
  }
}

class _ThreeDBrandPanel extends StatelessWidget {
  const _ThreeDBrandPanel();

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0012)
        ..rotateY(-0.08)
        ..rotateX(0.03),
      child: Container(
        constraints: const BoxConstraints(minHeight: 560),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xff38bdf8), Color(0xff0f172a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.38),
              blurRadius: 42,
              offset: const Offset(24, 30),
            ),
            BoxShadow(
              color: const Color(0xff67e8f9).withValues(alpha: 0.18),
              blurRadius: 34,
              offset: const Offset(-12, -10),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            image: const DecorationImage(
              image: AssetImage('assets/images/goex.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.72),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: 8,
                  right: 8,
                  child: _GlassBadge(
                    icon: Icons.auto_graph,
                    text: 'Live workspace',
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -12),
                      child: Image.asset(
                        'assets/images/trance.png',
                        height: 110,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Manage people, companies, and growth in one place.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'A focused workspace for administrators and company teams.',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThreeDLoginPanel extends StatelessWidget {
  const _ThreeDLoginPanel({required this.state});

  final _LoginScreenState state;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.watch<AuthBloc>().state.status == AuthStatus.loading;

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(0.07)
        ..rotateX(-0.025),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xffffffff), Color(0xff60a5fa), Color(0xff111827)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.42),
              blurRadius: 46,
              offset: const Offset(26, 34),
            ),
            BoxShadow(
              color: const Color(0xff93c5fd).withValues(alpha: 0.22),
              blurRadius: 28,
              offset: const Offset(-14, -14),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xfff8fafc).withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Form(
            key: state._formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Transform.translate(
                    offset: const Offset(0, -8),
                    child: Image.asset(
                      'assets/images/trance.png',
                      height: 98,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff111827),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to continue to your dashboard',
                  style: TextStyle(color: Color(0xff6b7280)),
                ),
                const SizedBox(height: 24),
                _LoginTextField(
                  controller: state.emailController,
                  label: 'Email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter email';
                    }
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _LoginTextField(
                  controller: state.passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: !state.isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      state.setState(() {
                        state.isPasswordVisible = !state.isPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter password';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xff111827,
                          ).withValues(alpha: 0.32),
                          blurRadius: 18,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: AppGradientButton(
                      text: "Sign In",

                      isLoading: isLoading,
                      onPressed: isLoading ? null : state.login,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DepthPlate extends StatelessWidget {
  const _DepthPlate({
    required this.width,
    required this.height,
    required this.color,
    required this.rotation,
  });

  final double width;
  final double height;
  final Color color;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: color,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 34,
              offset: const Offset(18, 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingCube extends StatelessWidget {
  const _FloatingCube({required this.size, this.rotation = 0.22});

  final double size;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateZ(rotation)
        ..rotateX(0.65)
        ..rotateY(0.48),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.34),
              const Color(0xff38bdf8).withValues(alpha: 0.22),
              const Color(0xff0f172a).withValues(alpha: 0.42),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.24),
              blurRadius: 24,
              offset: const Offset(12, 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  const _GlassBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xfff8fafc),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffe5e7eb)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffe5e7eb)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xff2563eb), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xffdc2626)),
        ),
      ),
    );
  }
}
