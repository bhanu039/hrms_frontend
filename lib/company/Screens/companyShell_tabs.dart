import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Companyshell extends StatelessWidget {
  final Widget child;

  const Companyshell({super.key, required this.child});

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/company/dashboard')) return 0;
    if (path.startsWith('/company/employees')) return 1;
    if (path.startsWith('/company/onboarding')) return 2;
    if (path.startsWith('/company/profile')) return 3;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _index(context);

    return Scaffold(
      body: child,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/company/dashboard');
              break;
            case 1:
              context.go('/company/employees');
              break;
            case 2:
              context.go('/company/onboarding');
              break;
            case 3:
              context.go('/company/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Employees"),
          BottomNavigationBarItem(icon: Icon(Icons.how_to_reg), label: "Onboarding"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}