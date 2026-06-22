import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/login_screen.dart';

import '../../core/state/auth/auth_bloc.dart';
import '../../core/state/auth/auth_event.dart';
import '../../core/widgets/menu_widget.dart';

class EmployeeDrawer extends StatelessWidget {
  const EmployeeDrawer({super.key});

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
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.home_rounded,
                  title: 'Home',
                  subtitle: 'Employee dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/emp/dashboard');
                  },
                ),
                DrawerWidgets.sectionTitle('Personal'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'View and edit your details',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/emp/profile');
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.work_outline,
                  title: 'My Tasks',
                  subtitle: 'Tasks and assignments',
                  onTap: () =>
                      DrawerWidgets.showComingSoon(context, 'My Tasks'),
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.event_available,
                  title: 'Attendance',
                  subtitle: 'Check your attendance history',
                  onTap: () =>context.push('/emp/attendance'),
                      
                ),
                DrawerWidgets.sectionTitle('Work'),
                // DrawerWidgets.menuTile(
                //   context,
                //   icon: Icons.how_to_reg_rounded,
                //   title: 'Onboarding',
                //   subtitle: 'Complete your profile and documents',
                //   onTap: () {
                //     context.go('/emp/onbording');
                //   },
                // ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.bar_chart,
                  title: 'Performance',
                  subtitle: 'Review your work summary',
                  onTap: () =>
                  context.go('/')
                      // DrawerWidgets.showComingSoon(context, 'Performance'),
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.insights,
                  title: 'Reports',
                  subtitle: 'View attendance and activity reports',
                  onTap: () => DrawerWidgets.showComingSoon(context, 'Reports'),
                ),
                DrawerWidgets.sectionTitle('Settings'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.settings,
                  title: 'Preferences',
                  subtitle: 'App settings and notifications',
                  onTap: () =>
                      DrawerWidgets.showComingSoon(context, 'Preferences'),
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
              subtitle: 'Exit employee account',
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
