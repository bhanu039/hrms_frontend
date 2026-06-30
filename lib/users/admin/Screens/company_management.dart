import 'package:flutter/material.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class SuperAdminScreen extends StatelessWidget {
  const SuperAdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Super Admin",
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Manage master settings and organization controls",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                isScrollable: true,
                dividerColor: AppColors.transparent,
                indicator: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: AppColors.black.withOpacity(0.06),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                labelColor: AppColors.black,
                unselectedLabelColor: AppColors.grey,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: "Industry Type"),
                  Tab(text: "Departments"),
                  Tab(text: "Designation"),
                  Tab(text: "Notifications"),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            AdminTabCard(
              title: "Industry Types",
              subtitle: "Manage available industry categories for companies.",
              icon: Icons.business_center_outlined,
            ),
            AdminTabCard(
              title: "Departments",
              subtitle: "Create and organize departments within organizations.",
              icon: Icons.apartment_outlined,
            ),
            AdminTabCard(
              title: "Designation",
              subtitle: "Manage employee roles and designation structures.",
              icon: Icons.badge_outlined,
            ),
            AdminTabCard(
              title: "Notifications",
              subtitle: "Send announcements and manage system notifications.",
              icon: Icons.notifications_active_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminTabCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const AdminTabCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 30, color: AppColors.blue),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                color: AppColors.grey.shade700,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: Text(
                  "$title Management Screen",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
