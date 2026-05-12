import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/company/Screens/employee_screen.dart';

import '../../login_screen.dart';
import '../../state/auth/auth_bloc.dart';
import '../../state/auth/auth_event.dart';
import 'company_profile_screen.dart';
import 'subscription_plans.dart';

class CompanyDrawer extends StatelessWidget {
  const CompanyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthBloc>().state.session;
    final name = session?.name ?? '';
    final email = session?.email ?? '';

    return Drawer(
      backgroundColor: Colors.grey.shade100,
      child: Column(
        children: [
          _buildHeader(name: name, email: email),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _sectionTitle('Company'),
                _menuTile(
                  context,
                  icon: Icons.business,
                  title: 'Company Profile',
                  subtitle: 'Details, address, logo',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CompanyProfileScreen(),
                      ),
                    );
                  },
                ),

                _menuTile(
                  context,
                  icon: Icons.workspace_premium,
                  title: 'Services & Expertise',
                  subtitle: 'Core strengths and offerings',
                ),
                _sectionTitle('Operations'),
                _menuTile(
                  context,
                  icon: Icons.people,
                  title: 'HRs',
                  subtitle: 'Teams and staff records',
                ),
                _menuTile(
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
                _menuTile(
                  context,
                  icon: Icons.work,
                  title: 'Projects',
                  subtitle: 'Active and completed work',
                ),
                _menuTile(
                  context,
                  icon: Icons.apartment,
                  title: 'Departments',
                  subtitle: 'Business units',
                ),
                _sectionTitle('Growth'),
                _menuTile(
                  context,
                  icon: Icons.insights,
                  title: 'Reports & Analytics',
                  subtitle: 'Performance and activity',
                ),
                _menuTile(
                  context,
                  icon: Icons.subscriptions,
                  title: 'Subscription',
                  subtitle: 'Plan and billing status',
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionPage(),
                      ),
                    ),
                  },
                ),
                _menuTile(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Account preferences',
                  subItems: [
                    _MenuSubItem(
                      icon: Icons.payments,
                      title: 'Payroll Settings',
                      onTap: () => _showComingSoon(context, 'Payroll Settings'),
                    ),
                    _MenuSubItem(
                      icon: Icons.work_history,
                      title: 'Work Settings',
                      onTap: () => _showComingSoon(context, 'Work Settings'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _menuTile(
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

  Widget _buildHeader({required String name, required String email}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 22, left: 18, right: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0f766e), Color(0xff2563eb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(Icons.business, size: 40, color: Color(0xff0f766e)),
          ),
          const SizedBox(height: 12),
          Text(
            name.isEmpty ? 'Company' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email.isEmpty ? 'company@email.com' : email,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color color = Colors.black87,
    VoidCallback? onTap,
    List<_MenuSubItem> subItems = const [],
  }) {
    if (subItems.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, color: color),
            ),
            subtitle: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: const EdgeInsets.only(
              left: 16,
              right: 8,
              bottom: 8,
            ),
            children: subItems
                .map(
                  (item) => ListTile(
                    dense: true,
                    leading: Icon(item.icon, size: 20, color: Colors.grey),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap:
                        item.onTap ??
                        () => _showComingSoon(context, item.title),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: onTap ?? () => _showComingSoon(context, title),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(content: Text('$title screen coming soon')),
    );
  }
}

class _MenuSubItem {
  const _MenuSubItem({required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
}
