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
  State<MainTabScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainTabScreen> {
  int currentIndex = 0;

  late List<Widget> screens;
  late List<NavItemModel> navItems;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final session = context.watch<AuthBloc>().state.session;
    final role = session?.role ?? "";

    /// ================= ADMIN =================

    if (role == "SUPER_ADMIN") {
      screens = const [DashboardScreen(), CompanyScreen(), ProfileScreen()];

      navItems = const [
        NavItemModel(icon: Icons.grid_view_rounded, label: "Dashboard"),

        NavItemModel(icon: Icons.groups_rounded, label: "Companies"),

        NavItemModel(
          icon: Icons.admin_panel_settings_rounded,
          label: "Profile",
        ),
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
        NavItemModel(icon: Icons.home_work_rounded, label: "Home"),

        NavItemModel(icon: Icons.people_alt_rounded, label: "Employees"),

        NavItemModel(icon: Icons.event_note_rounded, label: "Profile"),
      ];
    }
    /// ================= COMPANY =================
    else if (role == "OWNER") {
      screens = const [
        CDashboardScreen(),
        EmployeeListScreen(),
        CompanyProfileScreen(),
      ];

      navItems = const [
        NavItemModel(icon: Icons.dashboard_rounded, label: "Dashboard"),

        NavItemModel(icon: Icons.badge_rounded, label: "Staff"),

        NavItemModel(icon: Icons.business_center_rounded, label: "Profile"),
      ];
    } else if(role == "EMPLOYEE"){
      // screens = const [
      //   CDashboardScreen(),
      //   EmployeeListScreen(),
      //   CompanyProfileScreen(),
      // ];

      // navItems = const [

      //   NavItemModel(
      //     icon: Icons.dashboard_rounded,
      //     label: "Dashboard",
      //   ),

      //   NavItemModel(
      //     icon: Icons.badge_rounded,
      //     label: "Staff",
      //   ),

      //   NavItemModel(
      //     icon: Icons.business_center_rounded,
      //     label: "Profile",
      //   ),
      // ];

      TopMessage.show(context, "EMPLOYEE  ui not done ", color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      /// ================= BODY =================
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),

        child: IndexedStack(
          key: ValueKey(currentIndex),
          index: currentIndex,
          children: screens,
        ),
      ),

      /// ================= PREMIUM FLOATING NAV =================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),

          child: Container(
            height: 82,

            padding: const EdgeInsets.symmetric(horizontal: 10),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.96),

              borderRadius: BorderRadius.circular(32),

              border: Border.all(color: Colors.white, width: 1.5),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 30,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

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

  /// ================= NAVIGATION ITEM =================

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

          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),

          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xff2563eb), Color(0xff3b82f6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,

            borderRadius: BorderRadius.circular(22),

            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xff2563eb).withOpacity(.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 250),

                scale: isSelected ? 1.1 : 1,

                child: Icon(
                  icon,

                  size: 24,

                  color: isSelected ? Colors.white : Colors.grey.shade500,
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),

                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.horizontal,
                      child: child,
                    ),
                  );
                },

                child: isSelected
                    ? Padding(
                        key: ValueKey(label),

                        padding: const EdgeInsets.only(left: 8),

                        child: Text(
                          label,

                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: .2,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
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
