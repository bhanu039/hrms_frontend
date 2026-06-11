import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HrShell extends StatelessWidget {
  final Widget child;

  const HrShell({super.key, required this.child});

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/hr/dashboard')) return 0;
    if (path.startsWith('/hr/employees')) return 1;
    if (path.startsWith('/hr/onboarding')) return 2;
    if (path.startsWith('/hr/profile')) return 3;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _index(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: child,

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            currentIndex: index,
            type: BottomNavigationBarType.fixed,

            selectedItemColor: Colors.indigo,
            unselectedItemColor: Colors.grey,

            backgroundColor: Colors.white,
            elevation: 0,

            showUnselectedLabels: true,

            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),

            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
            ),

            onTap: (i) {
              switch (i) {
                case 0:
                  context.go('/hr/dashboard');
                  break;
                case 1:
                  context.go('/hr/employees');
                  break;
                case 2:
                  context.go('/hr/onboarding'); // FIXED
                  break;
                case 3:
                  context.go('/hr/profile');
                  break;
              }
            },

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_outlined),
                activeIcon: Icon(Icons.groups),
                label: "Employees",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.how_to_reg_outlined),
                activeIcon: Icon(Icons.how_to_reg),
                label: "Onboarding",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}