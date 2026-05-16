import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:goexperts/hr/screens/hr_dashbord.dart';

import 'admin/Screens/admin_prifile.dart';
import 'admin/Screens/companys_list.dart';
import 'admin/Screens/dashboard_screen.dart';

import 'company/Screens/c_dashboard_screen.dart';
import 'company/Screens/company_profile_screen.dart';
import 'company/Screens/employee_screen.dart';

import 'state/auth/auth_bloc.dart';
import 'widgets/top_message.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int currentIndex = 0;

  List<Widget> screens = [];
  List<NavItemModel> navItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final session = context.read<AuthBloc>().state.session;
    final role = session?.role ?? "";

    /// ================= SUPER ADMIN =================
    if (role == "SUPER_ADMIN") {
      screens = const [DashboardScreen(), CompanyScreen(), ProfileScreen()];

      navItems = const [
        NavItemModel(icon: Icons.space_dashboard_rounded, label: "Dashboard"),

        NavItemModel(icon: Icons.business_rounded, label: "Companies"),

        NavItemModel(icon: Icons.person_rounded, label: "Profile"),
      ];
    }
    /// ================= HR =================
    else if (role == "HR") {
      screens = const [
        HrDashboardScreen(),
        EmployeeListScreen(),
        CompanyProfileScreen(),
      ];

      navItems = const [
        NavItemModel(icon: Icons.home_rounded, label: "Home"),

        NavItemModel(icon: Icons.groups_rounded, label: "Employees"),

        NavItemModel(icon: Icons.person_outline_rounded, label: "Profile"),
      ];
    }
    /// ================= OWNER =================
    else if (role == "OWNER") {
      screens = const [
        CDashboardScreen(),
        EmployeeListScreen(),
        CompanyProfileScreen(),
      ];

      navItems = const [
        NavItemModel(
          icon: Icons.dashboard_customize_rounded,
          label: "Dashboard",
        ),

        NavItemModel(icon: Icons.badge_rounded, label: "Staff"),

        NavItemModel(icon: Icons.person_outline_rounded, label: "Profile"),
      ];
    }
    /// ================= EMPLOYEE =================
    else if (role == "EMPLOYEE") {
      TopMessage.show(context, "Employee UI Coming Soon", color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      /// ================= BODY =================
      body: screens.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),

              child: IndexedStack(
                key: ValueKey(currentIndex),
                index: currentIndex,
                children: screens,
              ),
            ),

      /// ================= PREMIUM BOTTOM NAV =================
      bottomNavigationBar: navItems.isEmpty
          ? const SizedBox()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),

                child: Container(
                  height: 85,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),

                    border: Border.all(color: Colors.grey.shade200),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Row(
                    children: List.generate(navItems.length, (index) {
                      final item = navItems[index];

                      return _buildNavItem(
                        icon: item.icon,
                        label: item.label,
                        index: index,
                      );
                    }),
                  ),
                ),
              ),
            ),
    );
  }

  /// ================= NAV ITEM =================

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          curve: Curves.easeInOut,

          alignment: Alignment.center,

          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),

          padding: const EdgeInsets.symmetric(vertical: 10),

          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 213, 140, 22),
                      Color(0xff3B82F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,

            borderRadius: BorderRadius.circular(22),

            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xff2563EB).withValues(alpha: 0.30),

                      blurRadius: 18,

                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 250),

                scale: isSelected ? 1.12 : 1,

                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),

             const SizedBox(width: 10),

              isSelected
                  ? Text(
                      label,
                      textAlign: TextAlign.center,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,

                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    )
                  : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}

/// ================= NAV MODEL =================

class NavItemModel {
  final IconData icon;
  final String label;

  const NavItemModel({required this.icon, required this.label});
}
