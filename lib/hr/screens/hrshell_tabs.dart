import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/nav_widgets.dart';
import '../../core/widgets/top_message.dart';

class HrShell extends StatelessWidget {
  final Widget child;

  const HrShell({super.key, required this.child});

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/hr/dashboard')) return 0;
    if (path.startsWith('/hr/employees')) return 1;
    if (path.startsWith('/hr/attendance')) return 2;
    if (path.startsWith('/hr/projects')) return 3;
    if (path.startsWith('/hr/profile')) return 4;

    return 0;
  }

  void _onTap(BuildContext context, int i) {
    switch (i) {
      case 0:
        context.go('/hr/dashboard');
        break;
      case 1:
        context.go('/hr/employees');
        break;
        case 2:
        context.go('/hr/attendance');
        break;
      case 3:
        // context.go('/hr/projects');
        TopMessage.show(context, "Projects feature is under development.\nComing Soon ",color: Colors.orange);
        break;
      case 4:
        context.go('/hr/profile');
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
                Expanded(
                  child: NavItem(
                    icon: Icons.dashboard_rounded,
                    label: "Home",
                    active: index == 0,
                    onTap: () => _onTap(context, 0),
                  ),
                ),
                Expanded(
                  child: NavItem(
                    icon: Icons.groups_rounded,
                    label: "Employees",
                    active: index == 1,
                    onTap: () => _onTap(context, 1),
                  ),
                ),
                Expanded(
                  child: NavItem(
                    icon: Icons.event_available_rounded,
                    label: "Attendance",
                    active: index == 2,
                    onTap: () => _onTap(context, 2),
                  ),
                ),
                
                Expanded(
                  child: NavItem(
                    icon: Icons.calendar_today_rounded,
                    label: "Projects",
                    active: index == 3,
                    onTap: () => _onTap(context, 3),
                  ),
                ),
                  NavItem(
                  icon: Icons.person_rounded,
                  label: "Profile",
                  active: index == 4,
                  onTap: () => _onTap(context, 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}