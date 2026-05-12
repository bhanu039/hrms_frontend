import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../models/employee_model.dart';
import 'employee_details.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<EmployeeModel> employees = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  /// ================= FETCH =================

  Future<void> fetchEmployees() async {
    try {
      final data = await ApiService.getEmployees();

      setState(() {
        employees = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(title: const Text("Employees"), centerTitle: true),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : employees.isEmpty
          ? const Center(child: Text("No Employees Found"))
          : ListView.builder(
              padding: const EdgeInsets.all(15),

              itemCount: employees.length,

              itemBuilder: (context, index) {
                final emp = employees[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(20),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EmployeeReviewScreen(employeecode: emp.id),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),

                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      children: [
                        Row(
                          children: [
                            /// IMAGE
                            CircleAvatar(
                              radius: 30,

                              backgroundColor: Colors.blue.shade100,

                              backgroundImage: emp.profilePhoto.isNotEmpty
                                  ? NetworkImage(
                                      "https://goexperts-hrms.onrender.com${emp.profilePhoto}",
                                    )
                                  : null,

                              child: emp.profilePhoto.isEmpty
                                  ? Text(
                                      emp.firstName[0],
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),

                            const SizedBox(width: 15),

                            /// DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "${emp.firstName} ${emp.lastName}",

                                    style: const TextStyle(
                                      fontSize: 18,

                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(emp.employeeCode),

                                  const SizedBox(height: 5),

                                  Text(emp.designation.title),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        /// STATUS
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,

                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: Column(
                                  children: [
                                    const Text("Status"),

                                    const SizedBox(height: 5),

                                    Text(
                                      emp.status,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,

                                  borderRadius: BorderRadius.circular(12),
                                ),

                                child: Column(
                                  children: [
                                    const Text("BGV"),

                                    const SizedBox(height: 5),

                                    Text(
                                      emp.bgvStatus,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        /// VIEW BUTTON
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  /// ================= INFO ROW =================

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [
          Expanded(
            flex: 4,

            child: Text(
              title,

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }
}
