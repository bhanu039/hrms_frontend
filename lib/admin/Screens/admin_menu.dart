import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../login_screen.dart';
import '../../core/state/auth/auth_bloc.dart';
import '../../core/state/auth/auth_event.dart';
import '../../core/widgets/menu_widget.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

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
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Admin account details',
                  onTap: () {
                    context.go("/admin/profile");
                  },
                ),
                DrawerWidgets.sectionTitle('Company Management'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.add_business,
                  title: 'Add Company',
                  subtitle: 'Register a new company',
                  onTap: () {
                    context.push("/admin/addcompany");
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.list_alt,
                  title: 'Companies List',
                  subtitle: 'View and manage companies',
                  onTap: () {
                    context.push('/admin/companies');
                  },
                ),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.list_alt,
                  title: ' Deleted Companies',
                  subtitle: 'View and manage companies deleted',
                  onTap: () {
                    context.push("/admin/deletedcompanies");
                  },
                ),
                DrawerWidgets.sectionTitle('Platform'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.subscriptions,
                  title: 'Subscription Plans',
                  subtitle: 'Plans, pricing, and duration',
                  onTap: () {
                    context.push("/admin/subscriptionadmin");
                  },
                ),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Industries',
                  subtitle: 'Manage industries',
                  onTap: () {
                    DrawerWidgets.showComingSoon(context, 'Industries');
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Departments',
                  subtitle: 'Manage departments',
                  onTap: () {
                    DrawerWidgets.showComingSoon(context, 'Departments');
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Designations',
                  subtitle: 'Manage designations',
                  onTap: () {
                    DrawerWidgets.showComingSoon(context, 'Designations');
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.bar_chart,
                  title: 'Reports & Analytics',
                  subtitle: 'Platform performance',
                  onTap: () {
                    DrawerWidgets.showComingSoon(
                      context,
                      'Reports & Analytics',
                    );
                  },
                ),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.settings,
                  title: 'System Settings',
                  subtitle: 'Controls and preferences',
                  subItems: [
                    MenuSubItem(
                      icon: Icons.security,
                      title: 'Security Settings',
                      onTap: () {
                        DrawerWidgets.showComingSoon(
                          context,
                          'Security Settings',
                        );
                      },
                    ),
                    MenuSubItem(
                      icon: Icons.tune,
                      title: 'General Settings',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/settings');
                      },
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
              subtitle: 'Exit admin account',
              color: Colors.red,
              onTap: () async {
                context.read<AuthBloc>().add(AuthLogoutRequested());
                await Future.delayed(const Duration(milliseconds: 100));

                context.go("/login");
              },
            ),
          ),
        ],
      ),
    );
  }
}
