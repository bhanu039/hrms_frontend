import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/widgets/custom_dailogbox.dart';

import '../../../core/services/api_service.dart';
import '../../../emp_list/employee_model.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class EmployeeListScreen extends StatefulWidget {
  
  final String role;

  const EmployeeListScreen({super.key, required this.role});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<EmployeeModel> employees = [];
  String? dataType;
  String? employeeTypes;

  bool isLoading = true;

  @override
  void initState() {
    employeeTypes = widget.role;
    fetchEmployees();
    super.initState();
  }

  /// ================= FETCH =================

  Future<void> fetchEmployees() async {
    try {
      final data = await ApiService.getEmployees(employeeTypes!, dataType!);

      setState(() {
        employees = data;
        isLoading = false;
      });
      print("uidata>>$data");
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  // 🗑 DELETE
  Future<void> deleteEmp(String id) async {
    setState(() {
      isLoading = true;
    });
    final apiService = ApiService();
    final bool success = await apiService.softDeleteEmp(id);

    if (!mounted) return;
    if (success) {
      CustomDialog.show(
        context: context,
        title: " Delete ",
        message: "Employee Deleted Success",
        icon: Icons.join_right_outlined,
        color: AppColors.successColor,
      );
      fetchEmployees();
    } else {
      CustomDialog.show(
        context: context,
        title: "Delete",
        message: " Deleted faild.",
        icon: Icons.error,
        color: AppColors.red,
      );
      fetchEmployees();
    }
  }

  Future<void> activateEmp(String id) async {
    setState(() {
      isLoading = true;
    });
    final apiService = ApiService();
    final bool success = await apiService.activateEmp(id);

    if (!mounted) return;

    if (success) {
      CustomDialog.show(
        context: context,
        title: " Activated ",
        message: "Employee Activated Success",
        icon: Icons.join_right_outlined,
        color: AppColors.successColor,
      );
      fetchEmployees();
    } else {
      CustomDialog.show(
        context: context,
        title: "Activation",
        message: " Activation faild.",
        icon: Icons.error,
        color: AppColors.red,
      );
      fetchEmployees();
    }
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey.shade100,

      appBar: AppBar(
        title: (dataType == "saftDelete")
            ? const Text("Delete Employees List")
            : const Text("Employees List"),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : employees.isEmpty
          ? const Center(child: Text("No Employees Found"))
          : Scaffold(
              body: Container(
                decoration:  BoxDecoration(
                  color: AppColors.screenBg,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final emp = employees[index];

                    return EmployeeCard(
                      emp: emp,
                      onTap: () {
                        final String empId = emp.id; // e.g., "emp-uuid-001"

                        // Use context.push to open it as an overlay child so the Back arrow button appears automatically
                        context.push('/onboarding/review/$empId');
                      },
                      onDelete: () {
                        deleteEmp(emp.id);
                      },
                      onStatusTap: () {
                        activateEmp(emp.id);
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final dynamic emp;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onStatusTap;

  const EmployeeCard({
    super.key,
    required this.emp,
    required this.onDelete,
    required this.onTap,
    required this.onStatusTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.surfaceElevated,
              border: Border.all(color: AppColors.borderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowSoft,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Automatically wraps tightly around rows
                children: [
                  /// TOP ROW
                  Row(
                    children: [
                      Hero(
                        tag: emp.id,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 34,
                            backgroundImage:
                                emp.profilePhoto != null &&
                                    emp.profilePhoto!.isNotEmpty
                                ? NetworkImage(emp.profilePhoto!)
                                : null,
                            child:
                                emp.profilePhoto == null ||
                                    emp.profilePhoto!.isEmpty
                                ? Text(
                                    emp.firstName[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${emp.firstName} ${emp.lastName}",
                              style:  TextStyle(
                                fontSize: 20,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                emp.employeeCode,
                                style:  TextStyle(
                                  color: AppColors.textSecondaryColor,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blueTint,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                emp.designation.title,
                                style:  TextStyle(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.dangerTint,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: onDelete,
                          icon:  Icon(
                            Icons.delete_outline,
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// BOTTOM ROW
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: onStatusTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: AppColors.warningTint,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                     Icon(
                                      Icons.person,
                                      color: AppColors.amberDark,
                                    ),
                                    const SizedBox(width: 5),
                                     Text(
                                      "STATUS",
                                      style: TextStyle(
                                        color: AppColors.textSecondaryColor,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  emp.status,
                                  style:  TextStyle(
                                    color: AppColors.amberDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: AppColors.blueTint,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Icon(
                                    Icons.verified_user,
                                    color: AppColors.info,
                                  ),
                                  const SizedBox(width: 5),
                                   Text(
                                    "onboardingCompleted",
                                    style: TextStyle(
                                      color: AppColors.textSecondaryColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),

                              Text(
                                emp.bgvStatus ? "Yes" : "No",
                                style:  TextStyle(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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



