import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SetPasswordScreen extends StatefulWidget {
  final String token;

  const SetPasswordScreen({super.key, required this.token});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;
  bool isLoading = false;

  String passwordError = "";
  String message = "";

  // 🔐 Password Validation
  String? validatePassword(String password) {
    if (password.length < 8) {
      return "Minimum 8 characters required";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "At least 1 uppercase letter required";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "At least 1 number required";
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      return "At least 1 special character required";
    }
    return null;
  }

  Future<void> setPassword() async {
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    final error = validatePassword(password);

    if (error != null) {
      setState(() => message = error);
      return;
    }

    if (password != confirm) {
      setState(() => message = "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
      message = "";
    });

    try {
      await ApiService.setPassword(token: widget.token, password: password);

      setState(() {
        isLoading = false;
        message = "Password set successfully ✅";
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        message = "Failed to set password ❌";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff4facfe), Color(0xff00f2fe)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Colors.black12),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 50, color: Colors.blue),

                  const SizedBox(height: 10),

                  const Text(
                    "Set New Password",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // 🔐 Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: obscure1,
                    onChanged: (value) {
                      setState(() {
                        passwordError = validatePassword(value) ?? "";
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure1 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => obscure1 = !obscure1);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // 🔴 Live validation error
                  if (passwordError.isNotEmpty)
                    Text(
                      passwordError,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 10),

                  // 📋 Rules
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• Minimum 8 characters"),
                        Text("• At least 1 uppercase letter"),
                        Text("• At least 1 number"),
                        Text("• At least 1 special character"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 🔐 Confirm Password
                  TextField(
                    controller: confirmController,
                    obscureText: obscure2,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure2 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => obscure2 = !obscure2);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔘 Button
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: setPassword,
                            child: const Text(
                              "Set Password",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                  const SizedBox(height: 10),

                  // ✅ Final message
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: TextStyle(
                        color: message.contains("success")
                            ? Colors.green
                            : Colors.red,
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
}
