
import 'package:flutter/material.dart';

import '../../widgets/top_message.dart';
import '../widgets/action_button.dart';
import '../widgets/small_info.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_tile.dart';

class HrDashboardScreen extends StatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen> {


   @override
  void initState() {
    super.initState();
     TopMessage.show(
            context,
            "Welcome, Super Admin!",
            color: Colors.green,
          );
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text("HR Dashboard"),
        backgroundColor: const Color.fromARGB(255, 196, 204, 244),
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic herer
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= STATS =================
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,

                  children:  [
                    StatCard(
                      title: "Employees",
                      count: "120",
                      icon: Icons.people,
                    ),
                    StatCard(
                      title: "Active",
                      count: "98",
                      icon: Icons.check_circle,
                    ),
                    StatCard(
                      title: "New Join",
                      count: "12",
                      icon: Icons.person_add,
                    ),
                    StatCard(
                      title: "Resigned",
                      count: "4",
                      icon: Icons.exit_to_app,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ================= QUICK ACTIONS =================
                const Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:  [
                    ActionButton(icon: Icons.person_add, label: "Add Employee" ,onPressed: ()=>TopMessage.show(context, "Employee added successfully!", color: Colors.green),),
                    ActionButton(icon: Icons.apartment, label: "Department", onPressed: ()=>TopMessage.show(context, "Department added successfully!", color: Colors.green),),
                    ActionButton(icon: Icons.badge, label: "Designation", onPressed: ()=>TopMessage.show(context, "Designation added successfully!", color: Colors.green),),
                    ActionButton(icon: Icons.campaign, label: "Announcement", onPressed: ()=>TopMessage.show(context, "Announcement added successfully!", color: Colors.green),),
                    ActionButton(icon: Icons.schedule, label: "Attendance", onPressed: ()=>TopMessage.show(context, "Attendance updated successfully!", color: Colors.green),),
                    ActionButton(icon: Icons.payments, label: "Payroll", onPressed: ()=>TopMessage.show(context, "Payroll processed successfully!", color: Colors.green),),
                  ],
                ),

                const SizedBox(height: 20),

                /// ================= ATTENDANCE =================
                const Text(
                  "Today Attendance",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SmallInfo(label: "Present", value: "85"),
                      SmallInfo(label: "Absent", value: "10"),
                      SmallInfo(label: "Late", value: "5"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= TASKS =================
                const Text(
                  "Pending Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const TaskTile(title: "5 Leave Requests Pending"),
                const TaskTile(title: "3 Onboarding Reviews"),
                const TaskTile(title: "2 Salary Approvals"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
