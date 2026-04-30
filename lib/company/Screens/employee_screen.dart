import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/api_service.dart';
import '../Bloc/employee_bloc.dart';

import '../state/employee_state.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmployeeBloc(ApiService())..add(LoadEmployees()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          title: const Text("Employees"),
          elevation: 0,
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEmployeeDialog(context),
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmployeeError) {
              return Center(child: Text(state.message));
            }

            if (state is EmployeeLoaded) {
              return Column(
                children: [
                  const SizedBox(height: 10),

                  // 🔍 Search bar (UI only)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search employee...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🧾 TABLE
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Column(
                          children: [
                            // HEADER
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Expanded(child: Text("ID", style: _headerStyle)),
                                  Expanded(child: Text("Name", style: _headerStyle)),
                                  Expanded(child: Text("Dept", style: _headerStyle)),
                                  Expanded(child: Text("Role", style: _headerStyle)),
                                  Expanded(child: Text("Salary", style: _headerStyle)),
                                ],
                              ),
                            ),

                            // DATA LIST
                            Expanded(
                              child: ListView.separated(
                                itemCount: state.employees.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final emp = state.employees[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 12),
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(emp.id.toString())),
                                        Expanded(child: Text(emp.name)),
                                        Expanded(child: Text(emp.department)),
                                        Expanded(child: Text(emp.role)),
                                        Expanded(child: Text("₹ ${emp.salary}")),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // 🧾 HEADER TEXT STYLE
  static const TextStyle _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // ➕ ADD EMPLOYEE DIALOG
  void _showAddEmployeeDialog(BuildContext context) {
    final nameController = TextEditingController();
    final deptController = TextEditingController();
    final roleController = TextEditingController();
    final salaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Add Employee"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _inputField("Name", nameController),
                _inputField("Department", deptController),
                _inputField("Role", roleController),
                _inputField("Salary", salaryController, isNumber: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final data = {
                  "name": nameController.text,
                  "department": deptController.text,
                  "role": roleController.text,
                  "salary": double.tryParse(salaryController.text) ?? 0,
                };

                context.read<EmployeeBloc>().add(CreateEmployee(data));
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // 🧾 INPUT FIELD WIDGET
  Widget _inputField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}