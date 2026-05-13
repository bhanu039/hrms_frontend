import 'package:flutter/material.dart';
import 'package:goexperts/services/api_client.dart';

import '../services/api_service.dart';
import '../state/models/user_session.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final formKey = GlobalKey<FormState>();

  final ApiService apiService = ApiService();

  /// ================= CONTROLLERS =================

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final salaryController = TextEditingController();
  final joiningDateController = TextEditingController();
  final positionController = TextEditingController();

  /// ================= DROPDOWN VALUES =================

  String? selectedRole;
  String? selectedDepartmentId;
  String? selectedDesignationId;

  bool isNewHire = true;

  bool isLoading = false;

  /// ================= API DATA =================

  List<Map<String, dynamic>> departments = [];
  List<Map<String, dynamic>> designations = [];

  @override
  void initState() {
    super.initState();

    selectedRole = currentUserSession?.isCompanyRole == true
        ? "HR"
        : "EMPLOYEE";

    loadInitialData();
  }

  /// ================= LOAD API =================

  Future<void> loadInitialData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final departmentResponse = await ApiClient.dio.get(
        "/departments?industryTypeId=id",
      );

      departments = List<Map<String, dynamic>>.from(
        departmentResponse.data["data"],
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// ================= SUBMIT =================

  Future<void> submitEmployee() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedDepartmentId == null) {
      showMessage("Please select department");
      return;
    }

    if (selectedDesignationId == null) {
      showMessage("Please select designation");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final body = {
        "email": emailController.text.trim(),
        "name": nameController.text.trim(),
        "role": selectedRole,
        "isNewHire": isNewHire,
        "departmentId": selectedDepartmentId,
        "designationId": selectedDesignationId,
        "offerData": {
          "salary": int.tryParse(salaryController.text) ?? 0,
          "joiningDate": joiningDateController.text,
          "position": positionController.text.trim(),
        },
      };

      debugPrint(body.toString());

      final response = await ApiClient.dio.post("/employees", data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessage("Employee Added Successfully");

        clearFields();

        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());

      showMessage("Something went wrong");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// ================= CLEAR =================

  void clearFields() {
    nameController.clear();
    emailController.clear();
    salaryController.clear();
    joiningDateController.clear();
    positionController.clear();

    selectedDepartmentId = null;
    selectedDesignationId = null;

    setState(() {});
  }

  /// ================= MESSAGE =================

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Add Employee",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: clearFields,
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadInitialData,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.all(20),

          child: Form(
            key: formKey,

            child: Column(
              children: [
                /// ================= TOP CARD =================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo, Colors.indigo.shade300],
                    ),

                    borderRadius: BorderRadius.circular(28),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: const Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white24,

                        child: Icon(
                          Icons.person_add_alt_1,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        "Employee Registration",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 6),

                      Text(
                        "Create onboarding employee",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// ================= FORM CARD =================
                buildSectionCard(
                  title: "Employee Details",
                  icon: Icons.badge_outlined,

                  children: [
                    buildField(
                      controller: nameController,
                      hint: "Employee Name",
                      icon: Icons.person_outline,
                    ),

                    buildField(
                      controller: emailController,
                      hint: "Email Address",
                      icon: Icons.email_outlined,
                    ),

                    buildRoleDropdown(),

                    buildDepartmentDropdown(),

                    buildDesignationDropdown(),

                    buildField(
                      controller: salaryController,
                      hint: "Salary",
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                    ),

                    buildDateField(),

                    buildField(
                      controller: positionController,
                      hint: "Position",
                      icon: Icons.work_outline,
                    ),

                    buildSwitchTile(),
                  ],
                ),

                const SizedBox(height: 30),

                /// ================= BUTTON =================
                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : submitEmployee,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Create Employee",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= CARD =================

  Widget buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(icon, color: Colors.indigo),
              ),

              const SizedBox(width: 14),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          ...children,
        ],
      ),
    );
  }

  /// ================= FIELD =================

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,

        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Required";
          }
          return null;
        },

        decoration: InputDecoration(
          hintText: hint,

          prefixIcon: Icon(icon),

          filled: true,
          fillColor: Colors.grey.shade100,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// ================= DATE FIELD =================

  Widget buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextFormField(
        controller: joiningDateController,
        readOnly: true,

        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Select joining date";
          }
          return null;
        },

        decoration: InputDecoration(
          hintText: "Joining Date",

          prefixIcon: const Icon(Icons.calendar_month),

          filled: true,
          fillColor: Colors.grey.shade100,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),

        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
            initialDate: DateTime.now(),
          );

          if (pickedDate != null) {
            joiningDateController.text = pickedDate.toString().split(" ")[0];
          }
        },
      ),
    );
  }

  /// ================= ROLE =================

  Widget buildRoleDropdown() {
    List<String> roles = [];

    if (currentUserSession?.isCompanyRole == true) {
      roles = ["HR", "EMPLOYEE"];
    } else {
      roles = ["EMPLOYEE"];
    }

    return dropdownContainer(
      child: DropdownButtonFormField<String>(
        initialValue: selectedRole,

        decoration: dropdownDecoration(Icons.admin_panel_settings_outlined),

        items: roles
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),

        onChanged: (value) {
          setState(() {
            selectedRole = value;
          });
        },
      ),
    );
  }

  /// ================= DEPARTMENT =================

  Widget buildDepartmentDropdown() {
    return dropdownContainer(
      child: DropdownButtonFormField<String>(
        initialValue: selectedDepartmentId,

        decoration: dropdownDecoration(Icons.apartment_outlined),

        hint: const Text("Select Department"),

        items: departments.map((department) {
          return DropdownMenuItem<String>(
            value: department["id"],
            child: Text(department["name"]),
          );
        }).toList(),

        onChanged: (value) async {
          setState(() {
            selectedDepartmentId = value;
            selectedDesignationId = null;
          });

          await getDesignations();
        },
      ),
    );
  }

  bool designationLoading = false;

  Future<void> getDesignations() async {
    if (selectedDepartmentId == null) return;

    setState(() {
      designationLoading = true;
    });

    try {
      final designationResponse = await ApiClient.dio.get(
        "/designations?departmentId=$selectedDepartmentId",
      );

      designations = List<Map<String, dynamic>>.from(
        designationResponse.data["data"],
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        designationLoading = false;
      });
    }
  }

  /// ================= DESIGNATION =================

  Widget buildDesignationDropdown() {
    return dropdownContainer(
      child: DropdownButtonFormField<String>(
        initialValue: selectedDesignationId,

        decoration: dropdownDecoration(Icons.workspace_premium_outlined),

        hint: const Text("Select Designation"),

        items: designations.map((designation) {
          return DropdownMenuItem<String>(
            value: designation["id"],
            child: Text(designation["name"]),
          );
        }).toList(),

        onChanged: (value) {
          setState(() {
            selectedDesignationId = value;
          });
        },
      ),
    );
  }

  /// ================= SWITCH =================

  Widget buildSwitchTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),

      child: SwitchListTile(
        value: isNewHire,

        title: const Text(
          "Is New Hire",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        onChanged: (value) {
          setState(() {
            isNewHire = value;
          });
        },
      ),
    );
  }

  /// ================= COMMON =================

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
