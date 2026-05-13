import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../login_screen.dart';
import '../services/set_pass_token.dart';
import 'top_message.dart';

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
      baseUrl: "https://goexperts-hrms.onrender.com/api/", // 🔁 change
      headers: {"Content-Type": "application/json"},
    ),
  );

  void submit() async {
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      TopMessage.show(context, "Fill all fields", color: Colors.red);
      return;
    }

    if (password != confirm) {
      TopMessage.show(context, "Passwords do not match", color: Colors.red);
      return;
    }

    setState(() => isLoading = true);

    try {
      print("Submitting new password with token: ${widget.token}");
      print(" Password: $password");
      final response = await dio.post(
        "invite/setup-password", // 🔁 your API
        data: {"token": widget.token, "password": password},
        options: Options(validateStatus: (status) => true),
      );

      print("Response: ${response.data}");

      if (response.statusCode == 200) {
        // ✅ MARK TOKEN USED ONLY AFTER SUCCESS
        await DeepLinkService.markTokenUsed(widget.token);

        TopMessage.show(context, "Password set successfully", color: Colors.green);
        Future.microtask(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        });
      } else
        (e) {
          TopMessage.show(
            context,
            "Failed to set password:  ${response.data['message'] ?? 'Unknown error'}",
            color: Colors.red,
          );
        };
    } on DioException catch (e) {
      print("Error: ${e.response?.data}");
      TopMessage.show(context, "Server error", color: Colors.red);
    } catch (e) {
      print("Error: $e");
      TopMessage.show(context, "Something went wrong", color: Colors.red);
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
            colors: [Color(0xff1e3a8a), Color(0xff9333ea)],
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_reset, size: 60, color: Colors.blue),
                  const SizedBox(height: 10),

                  const Text(
                    "Set New Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Enter your new password below",
                    style: TextStyle(color: Colors.grey),
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
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1e3a8a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Update Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: const Icon(Icons.login),
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
