import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';

import '../../login_screen.dart';
import '../../state/auth/auth_bloc.dart';
import '../../state/auth/auth_event.dart';
import '../../widgets/menu_widget.dart';
import 'admin_prifile.dart';
import 'company_reg.dart';
import 'companys_list.dart';
import 'subscription_plans.dart';

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
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                DrawerWidgets.sectionTitle('Company Management'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.add_business,
                  title: 'Add Company',
                  subtitle: 'Register a new company',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddCompanyScreen(),
                      ),
                    );
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.list_alt,
                  title: 'Companies List',
                  subtitle: 'View and manage companies',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CompanyScreen()),
                    );
                  },
                ),
                DrawerWidgets.sectionTitle('Platform'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.subscriptions,
                  title: 'Subscription Plans',
                  subtitle: 'Plans, pricing, and duration',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionAdminPage(),
                      ),
                    );
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Company Management',
                  subtitle: 'User access',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/users');
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.bar_chart,
                  title: 'Reports & Analytics',
                  subtitle: 'Platform performance',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/reports');
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Industries',
                  subtitle: 'Manage industries',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/users');
                  },
                ),
                 DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Departments',
                  subtitle: 'Manage departments',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/users');
                  },
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Designations',
                  subtitle: 'Manage designations',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/users');
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
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/settings');
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
