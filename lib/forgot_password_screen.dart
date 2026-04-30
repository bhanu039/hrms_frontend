import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
          backgroundColor: Colors.green,
        ),
      );

      if (!mounted) return;
      Navigator.pop(context); // go back to login
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  InputDecoration inputStyle() {
    return InputDecoration(
      labelText: "Email",
      prefixIcon: const Icon(Icons.email, color: Colors.red),

      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Colors.red,
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
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
