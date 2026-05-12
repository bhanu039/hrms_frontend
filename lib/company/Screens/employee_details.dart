import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../state/models/Employee_data_Model.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeReviewScreen extends StatefulWidget {
  final String employeecode;

  const EmployeeReviewScreen({super.key, required this.employeecode});

  @override
  State<EmployeeReviewScreen> createState() => _EmployeeReviewScreenState();
}

class _EmployeeReviewScreenState extends State<EmployeeReviewScreen> {
  EmployeeDataModel? employee;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployee();
  }

  /// ================= FETCH =================

  Future<void> fetchEmployee() async {
    try {
      final data = await ApiService.getEmployee(widget.employeecode);

      setState(() {
        employee = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (employee == null) {
      return const Scaffold(body: Center(child: Text("No employee data")));
    }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xffF4F7FC),

        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.indigo,

                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff4F46E5), Color(0xff7C3AED)],
                      ),
                    ),

                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// PROFILE
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                ),
                              ],
                            ),

                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white,

                              backgroundImage:
                                  employee?.profilePhoto.isNotEmpty == true
                                  ? NetworkImage(
                                      "https://goexperts-hrms.onrender.com${employee!.profilePhoto}",
                                    )
                                  : null,

                              child:
                                  employee != null &&
                                      employee!.profilePhoto.isEmpty
                                  ? Text(
                                      employee!.firstName[0],
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                          ),

                          const SizedBox(height: 18),

                          /// NAME
                          Text(
                            "${employee!.firstName} ${employee!.lastName}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// DESIGNATION
                          Text(
                            employee!.designation.title,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// EMP CODE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(30),
                            ),

                            child: Text(
                              employee!.employeeCode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// STATUS ROW
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildStatusChip(employee!.status, Colors.orange),

                              const SizedBox(width: 12),

                              buildStatusChip(
                                employee!.bgvStatus,
                                Colors.green,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),

                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,

                  tabs: [
                    Tab(text: "Overview"),
                    Tab(text: "Education"),
                    Tab(text: "Documents"),
                    Tab(text: "Bank"),
                  ],
                ),
              ),
            ];
          },

          body: TabBarView(
            children: [
              /// ================= OVERVIEW =================
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    buildSectionCard(
                      title: "Personal Information",

                      children: [
                        buildInfoTile(
                          Icons.person,
                          "Full Name",
                          "${employee!.firstName} ${employee!.lastName}",
                        ),

                        buildInfoTile(
                          Icons.email,
                          "Email",
                          employee!.user.email,
                        ),

                        buildInfoTile(
                          Icons.work,
                          "Department",
                          employee!.department.name,
                        ),

                        buildInfoTile(
                          Icons.badge,
                          "Designation",
                          employee!.designation.title,
                        ),

                        buildInfoTile(
                          Icons.calendar_month,
                          "Joining Date",
                          employee!.joiningDate != null
                              ? employee!.joiningDate.toString().split(" ")[0]
                              : '',
                        ),

                        buildInfoTile(
                          Icons.apartment,
                          "Employment Type",
                          employee!.employmentType,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    buildSectionCard(
                      title: "Skills",

                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,

                          children: employee!.skills.primarySkills.map((skill) {
                            return Chip(label: Text(skill));
                          }).toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    buildSectionCard(
                      title: "Experience",

                      children: employee!.experience.map((exp) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),

                          child: Container(
                            padding: const EdgeInsets.all(15),

                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  exp.companyName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(exp.role),

                                const SizedBox(height: 5),

                                Text(exp.technologies),

                                const SizedBox(height: 10),

                                Text(
                                  "${exp.totalYears} Years",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// ================= EDUCATION =================
              ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: employee!.education.length,

                itemBuilder: (context, index) {
                  final edu = employee!.education[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),

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
                        Text(
                          edu.degree,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(edu.specialization),

                        const SizedBox(height: 5),

                        Text(edu.college),

                        const SizedBox(height: 5),

                        Text(edu.university),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text("${edu.startYear} - ${edu.endYear}"),

                            Text(
                              edu.cgpa ?? edu.percentage ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// ================= DOCUMENTS =================
              ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: employee!.documents.length,

                itemBuilder: (context, index) {
                  final doc = employee!.documents[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                        ),
                      ],
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),

                      leading: Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.indigo.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.description,
                          color: Colors.indigo,
                        ),
                      ),

                      title: Text(
                        doc.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),

                        child: Text(doc.status),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        onPressed: () async {
                          // document file url from backend
                          final fileUrl =
                              "https://goexperts-hrms.onrender.com${doc.fileUrl}";
                          print("Document URL: $fileUrl");

                          // null or empty check
                          if (fileUrl == null || fileUrl.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("File not available"),
                              ),
                            );
                            return;
                          }

                          final Uri url = Uri.parse(fileUrl);

                          // open file
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        },

                        child: const Text(
                          "View",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),

              /// ================= BANK =================
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                child: buildSectionCard(
                  title: "Bank Details",

                  children: [
                    buildInfoTile(
                      Icons.account_balance,
                      "Bank Name",
                      employee!.bankDetails.bankName,
                    ),

                    buildInfoTile(
                      Icons.person,
                      "Account Holder",
                      employee!.bankDetails.accountHolderName,
                    ),

                    buildInfoTile(
                      Icons.credit_card,
                      "Account Number",
                      employee!.bankDetails.accountNumber,
                    ),

                    buildInfoTile(
                      Icons.code,
                      "IFSC Code",
                      employee!.bankDetails.ifscCode,
                    ),

                    buildInfoTile(
                      Icons.location_city,
                      "Branch",
                      employee!.bankDetails.branchName,
                    ),

                    buildInfoTile(
                      Icons.qr_code,
                      "UPI ID",
                      employee!.bankDetails.upiId,
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),

                        onPressed: () {},

                        child: const Text(
                          "Approve Employee",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),

                        onPressed: () {},

                        child: const Text(
                          "Reject Employee",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= STATUS CHIP =================

  Widget buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),

      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ================= SECTION CARD =================

  Widget buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          ...children,
        ],
      ),
    );
  }

  /// ================= INFO TILE =================

  Widget buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: Colors.indigo),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: TextStyle(color: Colors.grey.shade600)),

                const SizedBox(height: 5),

                Text(
                  value.isEmpty ? "-" : value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
