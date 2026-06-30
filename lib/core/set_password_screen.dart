import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'app_constants/app_constants.dart';
import 'services/set_pass_token.dart';
import 'state/auth/auth_bloc.dart';
import 'state/auth/auth_event.dart';
import 'widgets/app_primary_button.dart';
import 'widgets/top_message.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class SetPasswordScreen extends StatefulWidget {
  final String token;

  const SetPasswordScreen({super.key, required this.token});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmVisible = false;
  bool isLoading = false;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl2,
      headers: {"Content-Type": "application/json"},
    ),
  );

  void submit() async {
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      TopMessage.show(context, "Fill all fields", color: AppColors.red);
      return;
    }

    if (password != confirm) {
      TopMessage.show(context, "Passwords do not match", color: AppColors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      print("Submitting new password with token: ${widget.token}");
      print(" Password: $password");
      final response = await dio.post(
        "${AppConstants.apiBaseUrl2}invite/setup-password", // 🔁 your API
        data: {"token": widget.token, "password": password},
        options: Options(validateStatus: (status) => true),
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200 || response.data["success"] == true) {
        // ✅ MARK TOKEN USED ONLY AFTER SUCCESS
        await DeepLinkService.markTokenUsed(widget.token);

        TopMessage.show(
          context,
          "Password set successfully",
          color: AppColors.green,
        );
        Future.microtask(() async {
          context.read<AuthBloc>().add(AuthLogoutRequested());
          await Future.delayed(const Duration(milliseconds: 100));
          context.go("/login");
        });
      } else {
        print("Failed to set password: ${response.data}");
        TopMessage.show(
          context,
          response.data["message"] ?? "Failed to set password",
          color: AppColors.red,
        );
      }
    } catch (e) {
      print("Error: $e");
      TopMessage.show(context, "Something went wrong: $e", color: AppColors.red);
    }

    setState(() => isLoading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accentPurple, AppColors.warningColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_reset, size: 60, color: AppColors.secondaryColor),
                  const SizedBox(height: 10),

                  const Text(
                    "Set New Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                   Text(
                    "Enter your new password below",
                    style: TextStyle(color: AppColors.grey),
                  ),

                  const SizedBox(height: 25),

                  // 🔐 Password
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔐 Confirm Password
                  TextField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🚀 Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AppGradientButton(
                      text: "Create Password",

                      isLoading: isLoading,
                      onPressed: isLoading
                          ? () => TopMessage.show(
                              context,
                              "Please wait...",
                              color: AppColors.blue,
                            )
                          : submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}



