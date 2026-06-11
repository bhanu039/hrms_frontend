import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Empshell extends StatelessWidget {
  final Widget child;

  const Empshell({super.key, required this.child});

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/emp/dashboard')) return 0;
    if (path.startsWith('/emp/employees')) return 1; // FIXED
    if (path.startsWith('/emp/onboarding')) return 2;
    if (path.startsWith('/emp/profile')) return 3;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _index(context);

    return Scaffold(
      body: child,

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,

        showUnselectedLabels: true,

        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/emp/dashboard');
              break;

            case 1:
              context.go('/emp/employees'); // FIXED (was emo)
              break;

            case 2:
              context.go('/emp/onboarding');
              break;

            case 3:
              context.go('/emp/profile');
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
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
    );
  }
}
