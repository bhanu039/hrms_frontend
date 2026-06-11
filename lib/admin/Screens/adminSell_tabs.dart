import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/admin/dashboard')) return 0;
    if (path.startsWith('/admin/companies')) return 1;
    if (path.startsWith('/admin/profile')) return 2;

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
              context.go('/admin/dashboard');
              break;
            case 1:
              context.go('/admin/companies');
              break;
            case 2:
              context.go('/admin/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: "Companies"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}