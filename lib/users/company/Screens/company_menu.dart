import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/users/company/Screens/employees_list_screen.dart';

import '../../../core/state/auth/auth_bloc.dart';
import '../../../core/state/auth/auth_event.dart';
import '../../../core/widgets/menu_widget.dart';
import '../../../core/widgets/top_message.dart';

import '../../../core/widgets/location_get.dart';
import 'open_map.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class CompanyDrawer extends StatelessWidget {
  const CompanyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthBloc>().state.session;
    final name = session?.name ?? '';
    final email = session?.email ?? '';

    return Drawer(
      backgroundColor: AppColors.grey.shade100,
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
                  title: 'Company Profile',
                  subtitle: 'Details, address, logo',
                  onTap: () {
                    // Navigator.pop(context);
                    context.push('/company/profile');
                  },
                ),
               
                DrawerWidgets.sectionTitle('Operations'),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'HRs',
                  subtitle: 'Teams and staff records',
                   onTap: () => context.push('/company/employees' ,extra: {'role': 'Hr'},)
                ),
                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.people,
                  title: 'Employees',
                  subtitle: 'Teams and staff records',
                  onTap: () => context.push('/company/employees' ,extra:{'role': 'EMPLOYEE'},),
                ),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.work,
                  title: 'Projects',
                  subtitle: 'Active and completed work',
                  onTap: () => TopMessage.show(context, "Coming Soon" "Projects feature is under development.",color: AppColors.orange),
                ),
                 DrawerWidgets.menuTile(
                  context,
                  icon: Icons.workspace_premium,
                  title: 'Documents',
                  subtitle: 'Core Documents',
                  onTap: () {
                    // Navigator.pop(context);
                    context.push('/company/profile');
                  },
                ),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.workspace_premium,
                  title: 'Services & Expertise',
                  subtitle: 'Core strengths and offerings',
                ),

                DrawerWidgets.sectionTitle('Growth'),

                DrawerWidgets.menuTile(
                  context,
                  icon: Icons.subscriptions,
                  title: 'Subscription',
                  subtitle: 'Plan and billing status',
                  onTap: () => {context.push("/company/subscription")},
                ),

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
                      icon: Icons.label_outlined,
                      title: 'leaveTypes Settings',
                      onTap: () => context.push("/admin/leaveTypes")
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
                DrawerWidgets.sectionTitle('Appearance'),
                DrawerWidgets.themeModeTile(context),
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
              color: AppColors.red,
              onTap: () async {
                context.read<AuthBloc>().add(AuthLogoutRequested());

                await Future.delayed(const Duration(milliseconds: 300));

                context.go("/login");
              },
            ),
          ),
        ],
      ),
    );
  }
}



