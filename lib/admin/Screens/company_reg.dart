import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import '../../services/session_expiry_handler.dart';

import '../../widgets/custom_text_field.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({super.key});

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final adminEmailController = TextEditingController();
  final adminnameController = TextEditingController();
  final locationController = TextEditingController();
  bool isLoading = false;
  String? selectedindustriesId;

  List<Map<String, dynamic>> industries = [];

  void clearFields() {
    nameController.clear();
    emailController.clear();

    adminEmailController.clear();
    adminnameController.clear();
    locationController.clear();
  }

  @override
  void initState() {
    super.initState();

    loadInitialData();
  }

  /// ================= LOAD API =================

  Future<void> loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final industriesRes = await ApiClient.dio.get("master/industries");
      print(industriesRes.data["data"]);

      industries = List<Map<String, dynamic>>.from(industriesRes.data["data"]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createCompany() async {
    try {
      final response = await ApiService.createCompany(
        name: nameController.text,
        email: emailController.text,
        location: locationController.text,
        ownerName: adminnameController.text,
        ownerEmail: adminEmailController.text,
      );
      final success = response.data["success"] == true;
      final message =
          response.data["message"]?.toString() ??
          (success ? 'Company Registered Successfully' : 'Request failed');

      if (!mounted) return;
      if (success) {
        showSuccessDialog(message);
      } else {
        showError(message);
      }
    } catch (e) {
      if (e is DioException && e.error == "SESSION_EXPIRED") {
        SessionExpiryHandler.handle(context);
      } else {
        showError("Something went wrong");
      }
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 15),
              const Text(
                "Success",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(message),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);

                // 🔥 Clear form
                _formKey.currentState!.reset();
                clearFields();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    adminEmailController.dispose();
    adminnameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Widget space() => const SizedBox(height: 12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Company"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: nameController,
                    label: "Company Name",
                    prefixIcon: Icons.business,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter company name" : null,
                  ),
                  space(),

                  CustomTextField(
                    controller: emailController,
                    label: "Company Email",
                    prefixIcon: Icons.email,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Enter email";
                      if (!v.contains("@")) return "Invalid email";
                      return null;
                    },
                  ),
                  space(),

                  space(),

                  CustomTextField(
                    controller: adminnameController,
                    label: "Admin Name",
                    prefixIcon: Icons.person,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter admin name" : null,
                  ),
                  space(),

                  CustomTextField(
                    controller: adminEmailController,
                    label: "Admin Email",
                    prefixIcon: Icons.admin_panel_settings,
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Enter admin email";
                      if (!v.contains("@")) return "Invalid email";
                      return null;
                    },
                  ),
                  space(),
                  buildIndustriesDropdown(),

                  CustomTextField(
                    controller: locationController,
                    label: "Location",
                    prefixIcon: Icons.location_on,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Enter location" : null,
                  ),
                  space(),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => isLoading = true);

                                await createCompany();

                                setState(() => isLoading = false);
                              }
                            },
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Register Company",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

  Widget buildIndustriesDropdown() {
    return dropdownContainer(
      child: DropdownButtonFormField<String>(
        initialValue: selectedindustriesId,

        decoration: dropdownDecoration(Icons.apartment_outlined),

        hint: const Text("Select Department"),

        items: industries.map((department) {
          return DropdownMenuItem<String>(
            value: department["id"],
            child: Text(department["name"]),
          );
        }).toList(),

        onChanged: (value) async {
          setState(() {
            selectedindustriesId = value;
            selectedindustriesId = null;
          });
        },
      ),
    );
  }

  Widget dropdownContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),

      child: child,
    );
  }

  InputDecoration dropdownDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),

      border: InputBorder.none,

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    );
  }
}
