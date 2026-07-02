import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/widgets/top_message.dart';

import '../../core/state/auth/auth_bloc.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/dropdown_list.dart';
import '../bloc/invite_emp_bloc.dart';
import '../bloc/invite_emp_event.dart';
import '../bloc/invite_emp_start.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class InviteEmpScreen extends StatefulWidget {
  const InviteEmpScreen({super.key});

  @override
  State<InviteEmpScreen> createState() => _InviteEmpScreenState();
}

class _InviteEmpScreenState extends State<InviteEmpScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final salaryController = TextEditingController();
  final joiningDateController = TextEditingController();
  final positionController = TextEditingController();
  final officeDaysController = TextEditingController();
  String? role;
  String? roleController;
  String? workMode;

  bool isNew = false;

  @override
  void initState() {
    super.initState();

    final session = context.read<AuthBloc>().state.session;
    role = session?.role;

    context.read<InviteEmpBloc>().add(
      LoadEmployeeInitialData(session?.companyid! ?? ""),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InviteEmpBloc, InviteEmpState>(
      listener: (context, state) {
        if (state.success) {
          context.go('/');
          TopMessage.show(
            context,
            "Employee invited successfully!",
            color: AppColors.green,
          );
        } else if (state.error != null) {
          TopMessage.show(context, state.error!, color: AppColors.red);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.screenBg,

          appBar: AppBar(
            title: const Text("Add Employee"),
            centerTitle: true,
            elevation: 0,
          ),

          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        /// ================= ROLE CARD =================
                        _SectionCard(
                          title: "Basic Information",
                          children: [
                            AppDropdown(
                              label: "Role",
                              value: roleController,
                              items: (role != "HR")
                                  ? ["HR", "EMPLOYEE"]
                                  : ["EMPLOYEE"],
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please select a role";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  roleController = val;
                                });
                              },
                            ),

                            const SizedBox(height: 12),

                            CustomTextField(
                              label: "Employee Name",
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please enter employee name";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            CustomTextField(
                              label: "Employee Mail",
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                               validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Please enter employee mail";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// ================= ORGANIZATION =================
                        _SectionCard(
                          title: "Organization Details",
                          children: [
                            DropdownButtonFormField(
                              onTap: () {
                                // 🛡️ ALWAYS use .isEmpty to verify an array has 0 items
                                if (state.departments.isEmpty) {
                                  TopMessage.show(
                                    context,
                                    "No Departments available. Please add configurations first.",
                                    color: AppColors.accentOrange,
                                  );
                                }
                              },
                              value: state.selectedDepartmentId,
                              decoration: _dropdownDecoration("Department"),
                              items: state.departments
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e["id"],
                                      child: Text(e["name"]),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                context.read<InviteEmpBloc>().add(
                                  SelectDepartment(value.toString()),
                                );
                              },
                            ),

                            const SizedBox(height: 12),

                            DropdownButtonFormField(
                              value: state.selectedDesignationId,
                              decoration: _dropdownDecoration("Designation"),
                              items: state.designations
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e["id"],
                                      child: Text(e["title"]),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                context.read<InviteEmpBloc>().add(
                                  SelectDesignation(value.toString()),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              validator: (val){
                                if (val == null || val.isEmpty) {
                                  return "Please select a work mode";
                                }
                                return null;
                              },
                              value: state
                                  .workModel, // Ensure your state variable maps to the string values below
                              decoration: _dropdownDecoration("WorkMode"),

                              // FIX: Hardcoded work mode options mapped directly to items
                              items: const [
                                DropdownMenuItem(
                                  value: 'WFH',
                                  child: Text('Work From Home (WFH)'),
                                ),
                                DropdownMenuItem(
                                  value: 'WFO',
                                  child: Text('Work From Office (WFO)'),
                                ),
                                DropdownMenuItem(
                                  
                                  value: 'HYBRID',
                                  child: Text('Hybrid Work Model'),
                                  
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    workMode = value;
                                  });
                                  // Sends WFH, WFO, or HYBRID directly to your Bloc
                                }
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        if (state.workModel == "HYBRID")
                          CustomTextField(
                            label: "Expected OfficeDays",
                            controller: officeDaysController,
                            maxLength: 2,
                            keyboardType: TextInputType.number,
                             validator: (v) => v == null || v.isEmpty ? "Please enter expected office days" : null,
                          ),

                        /// ================= EMPLOYMENT TYPE =================
                        _SectionCard(
                          title: "Employment Type",
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.grey.shade200,
                                ),
                              ),
                              child: SwitchListTile(
                                value: isNew,
                                activeColor: AppColors.green,
                                title: Text(
                                  isNew ? "New Hire" : "Existing Employee",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() => isNew = val);
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        /// ================= CONDITIONAL FIELDS =================
                        if (isNew)
                          _SectionCard(
                            title: "Offer Details",
                            children: [
                              CustomTextField(
                                label: "Salary",
                                controller: salaryController,
                                keyboardType: TextInputType.number,
                              ),

                              const SizedBox(height: 12),

                              CustomTextField(
                                label: "Position",
                                controller: positionController,
                              ),

                              const SizedBox(height: 12),

                              CustomTextField(
                                label: "Date of Birth",
                                prefixIcon: const Icon(Icons.cake_outlined),
                                controller: joiningDateController,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365 * 50),
                                    ),
                                  );

                                  if (pickedDate != null) {
                                    joiningDateController.text =
                                        "${pickedDate.year}-"
                                        "${pickedDate.month.toString().padLeft(2, '0')}-"
                                        "${pickedDate.day.toString().padLeft(2, '0')}";
                                  }
                                },
                              ),
                            ],
                          ),

                        const SizedBox(height: 24),

                        /// ================= SUBMIT =================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                            ),
                            onPressed: state.submitting
                                ? null
                                : () {
                                  if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    final body = {
                                      "email": emailController.text.trim(),
                                      "name": nameController.text.trim(),
                                      "role": roleController,
                                      "isNewHire": isNew,

                                      "departmentId":
                                          state.selectedDepartmentId,
                                      "designationId":
                                          state.selectedDesignationId,
                                      "workModel": workMode,
                                      if (workMode == "HYBRID")
                                        "expectedOfficeDays":
                                            officeDaysController.text.trim(),

                                      if (isNew)
                                        "offerData": {
                                          "salary":
                                              int.tryParse(
                                                salaryController.text,
                                              ) ??
                                              0,
                                          "joiningDate":
                                              joiningDateController.text,
                                          "position": positionController.text
                                              .trim(),
                                        },
                                    };

                                    context.read<InviteEmpBloc>().add(
                                      SubmitEmployee(body),
                                    );
                                  },
                            child: state.submitting
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Submit"),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ AppColors.cardLightColor,AppColors.card,],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

InputDecoration _dropdownDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.grey.shade300),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.black),
    ),
  );
}
