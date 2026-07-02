import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/users/admin/Screens/companys_list.dart';
import '../../../core/services/api_service.dart';
import 'admin_menu.dart';
import 'company_reg.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

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
      backgroundColor: AppColors.backgroundColor,

      drawer: const AdminDrawer(),

      appBar: AppBar(
       
        centerTitle: false,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: AppColors.transparent,
        title: const Text(
          "Dashboard",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.black),
        actions: [
          Container(
            width: searchWidth,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.grey.shade100,
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
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Welcome back, Admin 👋\nHere’s your dashboard overview",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              fetchCompanies();
                            },

                      icon: const Icon(Icons.refresh, color: AppColors.white),
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
                            AppColors.blue,
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CompanyListScreen(
                                    status: "ALL",
                                  ), // 👈 create this screen
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
                            AppColors.green,
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CompanyListScreen(status: "ACTIVE"),
                                ),
                              );
                            },
                          ),

                          buildCard(
                            Icons.block,
                            "Inactive",
                            companies
                                .where((c) => c["status"] == "INACTIVE")
                                .length
                                .toString(),
                            AppColors.red,
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CompanyListScreen(
                                    status: "INACTIVE",
                                  ),
                                ),
                              );
                            },
                          ),

                          buildCard(
                            Icons.mail,
                            "Invited",
                            companies
                                .where((c) => c["status"] == "INVITED")
                                .length
                                .toString(),
                            AppColors.orange,
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
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.blue.shade50,
                                child: Icon(
                                  Icons.apartment,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      company["companyName"] ?? "No Name",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Company details here",
                                      style: TextStyle(
                                        color: AppColors.grey.shade600,
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
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
            Text(title, style: TextStyle(color: AppColors.grey)),
          ],
        ),
      ),
    );
  }

  // 🎨 STATUS COLOR
  Color getStatusColor(String? status) {
    switch (status) {
      case "ACTIVE":
        return AppColors.green;
      case "INACTIVE":
        return AppColors.red;
      case "INVITED":
        return AppColors.orange;
      default:
        return AppColors.grey;
    }
  }
}
