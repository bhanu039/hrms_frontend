import 'package:flutter/material.dart';
import '../login_screen.dart';

class SessionExpiryHandler {
  static bool isRedirecting = false;

  static void handle(BuildContext context) {
    if (isRedirecting) return;
    isRedirecting = true;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Session expired. Please login again."),
        backgroundColor: Colors.red,
      ),
    );
  }
}