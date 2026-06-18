import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/company/Screens/employee_screen.dart';
import 'package:goexperts/employe/emp_full_reg/screen/emp_full_reg_ui.dart';
import 'package:goexperts/hr/screens/hr_Profile.dart';

import '../../company/Screens/open_map.dart';
import '../../core/widgets/location_get.dart';
import '../../core/widgets/top_message.dart';
import '../../login_screen.dart';
import '../../core/state/auth/auth_bloc.dart';
import '../../core/state/auth/auth_event.dart';
import '../../core/widgets/menu_widget.dart';
import '../attendance/screen/emps_attendence.dart';

class HrDrawer extends StatelessWidget {
  const HrDrawer({super.key});

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
                DrawerWidgets.sectionTitle('Company'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.business,
                  title: 'Hr Profile',
                  subtitle: 'Details, address, logo',
                  onTap: () {
                    // Navigator.pop(context);
                    context.push('/hr/profile');
                  },
                ),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.workspace_premium,
                  title: 'Services & Expertise',
                  subtitle: 'Core strengths and offerings',
                ),
                DrawerWidgets.sectionTitle('Operations'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Attendance',
                  subtitle: 'manage attendance',
                  onTap: () => context.push('/hr/attendance'),
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Employees',
                  subtitle: 'Teams and staff records',
                  onTap: () => context.push('/hr/employees'),
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.work,
                  title: 'Projects',
                  subtitle: 'Active and completed work',
                  onTap: () => TopMessage.show(
                    context,
                    "Projects feature is under development.\nComing Soon ",
                    color: Colors.orange,
                  ),
                ),
               
                DrawerWidgets.sectionTitle('Growth'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.insights,
                  title: 'Reports & Analytics',
                  subtitle: 'Performance and activity',
                ),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'Account preferences',
                  subItems: [
                    MenuSubItem(
                      icon: Icons.people,
                      title: 'Departments',

                      onTap: () {
                        DrawerWidgets.showComingSoon(context, 'Departments');
                      },
                    ),
                    MenuSubItem(
                      icon: Icons.people,
                      title: 'Designations',

                      onTap: () {
                        DrawerWidgets.showComingSoon(context, 'Designations');
                      },
                    ),

                    MenuSubItem(
                      icon: Icons.payments,
                      title: 'Payroll Settings',
                      onTap: () => DrawerWidgets.showComingSoon(
                        context,
                        'Payroll Settings',
                      ),
                    ),
                    MenuSubItem(
                      icon: Icons.payments,
                      title: 'Date & Time Settings',
                      onTap: () => DrawerWidgets.showComingSoon(
                        context,
                        'Date & Time Settings',
                      ),
                    ),
                    
                    MenuSubItem(
                      icon: Icons.payments,
                      title: 'Location Settings',
                      onTap: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 2),
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Text("Fetching location..."),
                              ],
                            ),
                          ),
                        );

                        final locationData =
                            await LocationHelper.getCurrentLocation();

                        if (locationData != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapScreen(
                                latitude: locationData["latitude"],
                                longitude: locationData["longitude"],
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(" fetching location")),
                          );
                        }
                      },
                    ),
                    MenuSubItem(
                      icon: Icons.work_history,
                      title: 'Work Settings',
                      onTap: () => DrawerWidgets.showComingSoon(
                        context,
                        'Work Settings',
                      ),
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
}
