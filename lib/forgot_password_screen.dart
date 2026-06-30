import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      Dio dio = Dio();

      Response response = await dio.post(
        "https://yourapi.com/forgot-password",
        data: {"email": emailController.text},
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.data["message"] ?? "Reset link sent"),
          backgroundColor: AppColors.success,
        ),
      );

      if (!mounted) return;
      Navigator.pop(context); // go back to login
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: AppColors.warning,
        ),
      );
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  InputDecoration inputStyle() {
    return InputDecoration(
      labelText: "Email",
      prefixIcon: const Icon(Icons.email, color: AppColors.orange),

      filled: true,
      fillColor: AppColors.grey50,

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.orange, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: AppColors.accentOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),

              const Text(
                "Enter your email to receive reset link",
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: emailController,
                decoration: inputStyle(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email required";
                  }
                  if (!value.contains("@")) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : sendResetLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.backgroundColor,
                        )
                      : const Text("Send Reset Link"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
