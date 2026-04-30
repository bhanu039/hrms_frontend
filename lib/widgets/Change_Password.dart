import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/sessionservice.dart';

void showChangePasswordDialog(BuildContext context) {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool loading = false;
  bool obscureOld = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔐 TITLE
                    Row(
                      children: const [
                        Icon(Icons.lock, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // OLD PASSWORD
                    TextFormField(
                      controller: oldPass,
                      obscureText: obscureOld,
                      validator: (v) =>
                          v!.isEmpty ? "Enter old password" : null,
                      decoration: InputDecoration(
                        labelText: "Old Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureOld
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => obscureOld = !obscureOld),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // NEW PASSWORD
                    TextFormField(
                      controller: newPass,
                      obscureText: obscureNew,
                      validator: (v) {
                        if (v!.length < 6) return "Min 6 characters";
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "New Password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNew
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => obscureNew = !obscureNew),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // CONFIRM PASSWORD
                    TextFormField(
                      controller: confirmPass,
                      obscureText: obscureConfirm,
                      validator: (v) {
                        if (v != newPass.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        prefixIcon: const Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () =>
                              setState(() => obscureConfirm = !obscureConfirm),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ACTION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: loading
                                ? null
                                : () => Navigator.pop(dialogContext),
                            child: const Text("Cancel"),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: loading
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }

                                    final userId = await SessionService.getID();

                                    if (userId == null || userId.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("User ID not found"),
                                        ),
                                      );
                                      return;
                                    }

                                    setState(() => loading = true);

                                    try {
                                      final res =
                                          await ApiService.changePassword(
                                            userId,
                                            oldPass.text,
                                            newPass.text,
                                          );

                                      Navigator.pop(dialogContext);

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            res["message"] ?? "Success",
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
                                    }

                                    setState(() => loading = false);
                                  },
                            child: loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Update"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
