import 'package:flutter/material.dart';

class EmployeeProjectScreen extends StatefulWidget {
  const EmployeeProjectScreen({super.key});

  @override
  State<EmployeeProjectScreen> createState() => _EmployeeProjectScreenState();
}

class _EmployeeProjectScreenState extends State<EmployeeProjectScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> teamMembers = [
    "John",
    "David",
    "Sarah",
    "Alex",
  ];

  final List<Map<String, dynamic>> tasks = [
    {"title": "Design Login Screen", "completed": true},
    {"title": "API Integration", "completed": true},
    {"title": "Dashboard Development", "completed": false},
    {"title": "Testing & QA", "completed": false},
  ];

  final List<String> files = [
    "Requirements.pdf",
    "UI_Design.fig",
    "API_Documentation.pdf",
  ];

  final List<Map<String, String>> activities = [
    {
      "date": "12 May 2026",
      "message": "Login module completed successfully."
    },
    {
      "date": "15 May 2026",
      "message": "Backend APIs integrated."
    },
    {
      "date": "20 May 2026",
      "message": "Dashboard development started."
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.folder_copy, color: Colors.indigo),
                      SizedBox(width: 10),
                      Text(
                        "CRM Mobile App",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Chip(
                        backgroundColor: Colors.green.shade100,
                        label: const Text("Active"),
                      ),
                      const SizedBox(width: 10),
                      Chip(
                        backgroundColor: Colors.red.shade100,
                        label: const Text("High Priority"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Client"),
                      Text("ABC Technologies"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Project Manager"),
                      Text("Michael Johnson"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Start Date"),
                      Text("01 May 2026"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Deadline"),
                      Text("30 Jun 2026"),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Project Progress",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: 0.75,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  const SizedBox(height: 10),

                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text("75%"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTasksTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return Card(
          child: CheckboxListTile(
            value: task["completed"],
            onChanged: (_) {},
            title: Text(task["title"]),
          ),
        );
      },
    );
  }

  Widget buildTeamTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: teamMembers.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Text(
                teamMembers[index][0],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(teamMembers[index]),
            subtitle: const Text("Team Member"),
          ),
        );
      },
    );
  }

  Widget buildFilesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: files.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(
              Icons.picture_as_pdf,
              color: Colors.red,
            ),
            title: Text(files[index]),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }

  Widget buildActivityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.indigo,
            ),
            title: Text(activities[index]["message"]!),
            subtitle: Text(activities[index]["date"]!),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Details"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "Overview"),
            Tab(text: "Tasks"),
            Tab(text: "Team"),
            Tab(text: "Files"),
            Tab(text: "Activity"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildOverviewTab(),
          buildTasksTab(),
          buildTeamTab(),
          buildFilesTab(),
          buildActivityTab(),
        ],
      ),
    );
  }
}