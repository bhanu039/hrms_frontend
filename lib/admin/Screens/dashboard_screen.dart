import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/admin/Screens/companys_list.dart';
import '../../core/services/api_service.dart';
import '../../core/widgets/top_message.dart';
import 'admin_menu.dart';
import 'company_reg.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<AdminDashboardScreen> {
  List companies = [];
  List filteredCompanies = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //  TopMessage.show(
    //         context,
    //         "Welcome, Super Admin!",
    //         color: Colors.green,
    //       );
    fetchCompanies();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // 🔥 API CALL
  Future<void> fetchCompanies() async {
    isLoading = true;
    try {
      var result = await ApiService.getCompanies();
      print("Fetched ${result["companies"]?.length ?? 0} companies");

      setState(() {
        companies = result["companies"] ?? [];
        filteredCompanies = companies;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // 🔍 SEARCH
  void searchCompanies(String query) {
    setState(() {
      filteredCompanies = companies
          .where(
            (c) => c["name"].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double searchWidth = width < 600 ? 160 : 260;

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),

      drawer: const AdminDrawer(),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Container(
            width: searchWidth,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: searchController,
              onChanged: searchCompanies,
              decoration: const InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      // ➕ Floating Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push("/admin/addcompany");
        },
        label: const Text("Add Company"),
        icon: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: fetchCompanies,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 Welcome Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue.shade700],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Welcome back, Admin 👋\nHere’s your dashboard overview",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: fetchCompanies,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 Dashboard Cards
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: isLoading == true
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.count(
                        key: const ValueKey(1),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: width < 500 ? 2 : 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.3,
                        children: [
                          buildCard(
                            Icons.apartment,
                            "Companies",
                            companies.length.toString(),
                            Colors.blue,
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CompanyListScreen(), // 👈 create this screen
                                ),
                              );
                            },
                          ),
                          buildCard(
                            Icons.people,
                            "Active",
                            companies
                                .where((c) => c["status"] == "ACTIVE")
                                .length
                                .toString(),
                            Colors.green,
                            onPress: () {
                              setState(() {
                                filteredCompanies = companies
                                    .where((c) => c["status"] == "ACTIVE")
                                    .toList();
                              });
                            },
                          ),

                          buildCard(
                            Icons.block,
                            "Inactive",
                            companies
                                .where((c) => c["status"] == "INACTIVE")
                                .length
                                .toString(),
                            Colors.red,
                            onPress: () {
                              setState(() {
                                filteredCompanies = companies
                                    .where((c) => c["status"] == "INACTIVE")
                                    .toList();
                              });
                            },
                          ),

                          buildCard(
                            Icons.mail,
                            "Invited",
                            companies
                                .where((c) => c["status"] == "INVITED")
                                .length
                                .toString(),
                            Colors.orange,
                            onPress: () {
                              setState(() {
                                filteredCompanies = companies
                                    .where((c) => c["status"] == "INVITED")
                                    .toList();
                              });
                            },
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Recent Companies",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredCompanies.isEmpty
                  ? const Text("No companies found")
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredCompanies.length > 5
                          ? 5
                          : filteredCompanies.length,
                      itemBuilder: (context, index) {
                        final company = filteredCompanies[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue.shade50,
                                child: const Icon(
                                  Icons.apartment,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      company["name"] ?? "No Name",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Company details here",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Status Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(
                                    company["status"],
                                  ).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  company["status"] ?? "UNKNOWN",
                                  style: TextStyle(
                                    color: getStatusColor(company["status"]),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 CARD WIDGET
  Widget buildCard(
    IconData icon,
    String title,
    String value,
    Color color, {
    VoidCallback? onPress, // 👈 ADD THIS
  }) {
    return InkWell(
      onTap: onPress, // 👈 HANDLE CLICK
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // 🎨 STATUS COLOR
  Color getStatusColor(String? status) {
    switch (status) {
      case "ACTIVE":
        return Colors.green;
      case "INACTIVE":
        return Colors.red;
      case "INVITED":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
