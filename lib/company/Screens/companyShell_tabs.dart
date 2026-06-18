import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/widgets/top_message.dart';
import '../../core/widgets/nav_widgets.dart';

class CompanyShell extends StatelessWidget {
  final Widget child;

  const CompanyShell({super.key, required this.child});

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/company/dashboard')) return 0;
    if (path.startsWith('/company/employees')) return 1;
    if (path.startsWith('/company/Projects')) return 2;
    if (path.startsWith('/company/profile')) return 3;

    return 0;
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
                  onTap: () => context.go('/company/dashboard'),
                ),
      
                NavItem(
                  icon: Icons.groups_rounded,
                  label: "Employees",
                  active: index == 1,
                  onTap: () => context.go('/company/employees/' ,extra: ''),
                ),
      
                NavItem(
                  icon: Icons.how_to_reg_rounded,
                  label: "Projects",
                  active: index == 2,
                  onTap: () =>TopMessage.show(context, "Projects Coming Soon!",color: Colors.orange),
                ),
      
                NavItem(
                  icon: Icons.person_rounded,
                  label: "Profile",
                  active: index == 3,
                  onTap: () => context.go('/company/profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

