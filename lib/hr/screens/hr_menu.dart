import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/company/Screens/employee_screen.dart';

import '../../login_screen.dart';
import '../../state/auth/auth_bloc.dart';
import '../../state/auth/auth_event.dart';
import '../../widgets/menu_widget.dart';


class HrDrawer extends StatelessWidget {
  const HrDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthBloc>().state.session;
    final name = session?.name ?? '';
    final email = session?.email ?? '';

    return Drawer(
      backgroundColor: Colors.grey.shade100,
      child: Column(
        children: [
          DrawerWidgets.buildHeader(name: name, email: email),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                DrawerWidgets.sectionTitle('Company'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.business,
                  title: 'Hr Profile',
                  subtitle: 'Details, address, logo',
                  // onTap: () {
                  //   Navigator.pop(context);
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (_) => const CompanyProfileScreen(),
                  //     ),
                  //   );
                  // },
                ),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.workspace_premium,
                  title: 'Services & Expertise',
                  subtitle: 'Core strengths and offerings',
                ),
                DrawerWidgets.sectionTitle('Operations'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Attendance',
                  subtitle: 'manage attendance',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmployeeListScreen(),
                    ),
                  ),
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Employees',
                  subtitle: 'Teams and staff records',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmployeeListScreen(),
                    ),
                  ),
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.work,
                  title: 'Projects',
                  subtitle: 'Active and completed work',
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.apartment,
                  title: 'Departments',
                  subtitle: 'Business units',
                ),
                DrawerWidgets.sectionTitle('Growth'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.apartment,
                  title: 'Departments',
                  subtitle: 'Business units',
                ),
                DrawerWidgets.sectionTitle('Growth'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.insights,
                  title: 'Reports & Analytics',
                  subtitle: 'Performance and activity',
                ),
                
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Account preferences',
                  subItems: [
                    MenuSubItem(
                      icon: Icons.payments,
                      title: 'Payroll Settings',
                      onTap: () => DrawerWidgets.showComingSoon(context, 'Payroll Settings'),
                    ),
                   MenuSubItem(
                      icon: Icons.work_history,
                      title: 'Work Settings',
                      onTap: () => DrawerWidgets.showComingSoon(context, 'Work Settings'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: DrawerWidgets.menuTile(
              context,
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Exit company account',
              color: Colors.red,
              onTap: () {
                context.read<AuthBloc>().add(AuthLogoutRequested());
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
