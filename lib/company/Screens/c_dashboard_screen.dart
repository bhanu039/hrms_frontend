import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../state/bloc/auth/auth_bloc.dart';
import '../../widgets/dashboard_card.dart';
import 'company_menu.dart';
import 'company_profile_screen.dart';

class CDashboardScreen extends StatelessWidget {
  const CDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthBloc>().state.session;
    final companyName = (session?.name ?? '').trim();
    final displayName = companyName.isEmpty ? 'Company' : companyName;

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      drawer: const CompanyDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(displayName: displayName),
                  const SizedBox(height: 18),
                  _SearchField(),
                  const SizedBox(height: 18),
                  _HeroPanel(displayName: displayName),
                  const SizedBox(height: 18),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isWide ? 4 : 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: isWide ? 1.25 : 1.15,
                    children: const [
                      DashboardCard(
                        title: 'Employees',
                        value: '120',
                        icon: Icons.people,
                        color: Color(0xff2563eb),
                        change: '',
                      ),
                      DashboardCard(
                        title: 'Departments',
                        value: '8',
                        icon: Icons.apartment,
                        color: Color(0xff16a34a),
                        change: '',
                      ),
                      DashboardCard(
                        title: 'Projects',
                        value: '25',
                        icon: Icons.work,
                        color: Color(0xfff97316),
                        change: '',
                      ),
                      DashboardCard(
                        title: 'Industry Score',
                        value: '92%',
                        icon: Icons.insights,
                        color: Color(0xff7c3aed),
                        change: '',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff111827),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _QuickActions(
                    onProfileTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CompanyProfileScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(
          builder: (context) => IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xff111827),
            ),
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $displayName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111827),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Manage your company workspace',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xff6b7280)),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xff0f766e).withValues(alpha: 0.12),
          child: const Icon(Icons.business, color: Color(0xff0f766e)),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search employees, projects, departments',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0f766e), Color(0xff2563eb)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Company Workspace',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track people, departments, active projects, and company readiness from one place.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onProfileTap});

  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _ActionChipButton(
          icon: Icons.business,
          label: 'Profile',
          onTap: onProfileTap,
        ),
        _ActionChipButton(
          icon: Icons.people,
          label: 'Employees',
          onTap: () => _showComingSoon(context, 'Employees'),
        ),
        _ActionChipButton(
          icon: Icons.work,
          label: 'Projects',
          onTap: () => _showComingSoon(context, 'Projects'),
        ),
        _ActionChipButton(
          icon: Icons.insights,
          label: 'Reports',
          onTap: () => _showComingSoon(context, 'Reports'),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$title screen coming soon')));
  }
}

class _ActionChipButton extends StatelessWidget {
  const _ActionChipButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffe5e7eb)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 19, color: const Color(0xff0f766e)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xff111827),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
