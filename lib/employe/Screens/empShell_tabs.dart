import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/nav_widgets.dart';

class Empshell extends StatelessWidget {
  final Widget child;

  const Empshell({super.key, required this.child});

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/emp/dashboard')) return 0;
    if (path.startsWith('/emp/employees')) return 1;
    if (path.startsWith('/emp/onboarding')) return 2;
    if (path.startsWith('/emp/profile')) return 3;

    return 0;
  }

  void _onTap(BuildContext context, int i) {
    switch (i) {
      case 0:
        context.go('/emp/dashboard');
        break;
      case 1:
        context.go('/emp/employees');
        break;
      case 2:
        context.go('/emp/onboarding');
        break;
      case 3:
        context.go('/emp/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final index = _index(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: child,
      
        /// ================= MODERN FLOATING NAV =================
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
      
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(
                  icon: Icons.home_rounded,
                  label: "Home",
                  active: index == 0,
                  onTap: () => _onTap(context, 0),
                ),
                NavItem(
                  icon: Icons.groups_rounded,
                  label: "Employees",
                  active: index == 1,
                  onTap: () => _onTap(context, 1),
                ),
                NavItem(
                  icon: Icons.how_to_reg_rounded,
                  label: "Onboard",
                  active: index == 2,
                  onTap: () => _onTap(context, 2),
                ),
                NavItem(
                  icon: Icons.person_rounded,
                  label: "Profile",
                  active: index == 3,
                  onTap: () => _onTap(context, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}