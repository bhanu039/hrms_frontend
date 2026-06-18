import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goexperts/core/services/api_service.dart';

import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../../hr/hr_dashbord/data/hr_dashbord_repo.dart';
import 'employee_menu.dart';
import '../../hr/widgets/action_button.dart';
import '../../hr/widgets/small_info.dart';
import '../../hr/widgets/stat_card.dart';
import '../../hr/widgets/task_tile.dart';
import '../../core/services/sessionservice.dart';
import '../../core/widgets/custom_dailogbox.dart';
import '../../core/widgets/face_detact.dart';
import '../../core/widgets/location_get.dart';

import '../../core/widgets/top_message.dart';

class EmpDashboardScreen extends StatefulWidget {
  const EmpDashboardScreen({super.key});

  @override
  State<EmpDashboardScreen> createState() => _EmpDashboardScreenState();
}

class _EmpDashboardScreenState extends State<EmpDashboardScreen> {
  File? imagefile;
  bool isFinished = false;
  bool isLoading = false;

  double? latitude;
  double? longitude;

  Timer? timer;

  DateTime? checkInTime;
  DateTime? checkoutTime;

  Duration workingDuration = Duration.zero;

  bool isCheckedIn = false;

  bool islocation = false;
  bool isImage = false;

  // =========================
  // CHECK IN
  // =========================
  final repository = HrDashboardRepository();

  Future<void> checkIn() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      islocation = false;
      isImage = false;
      imagefile = null;
    });

    final location = await LocationHelper.getCurrentLocation();
    if (!mounted) return;

    if (location == null) {
      CustomDialog.show(
        context: context,
        title: "Location Not Detected",
        message: "Please enable GPS to continue.",
        icon: Icons.error,
        color: Colors.red,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      latitude = location["latitude"];
      longitude = location["longitude"];
      islocation = true;
    });
    print("Location detected: $latitude, $longitude");

    CustomDialog.show(
      context: context,
      title: "Location Detected",
      message: "GPS location captured successfully.",
      icon: Icons.check_circle,
      color: Colors.green,
    );

    await _captureFace();
    if (!mounted) return;

    if (!isImage || imagefile == null) {
      _showMissingFaceMessage();
      setState(() {
        isLoading = false;
        islocation = false;
      });
      return;
    }

    final response = await repository.checkinData(imagefile!, latitude!, longitude!);
    if (!mounted) return;

    if (response["success"] == true) {
      checkInTime = DateTime.now();
      workingDuration = Duration.zero;
      await SessionService.save(workingDuration);
      if (!mounted) return;

      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || checkInTime == null) return;

        setState(() {
          workingDuration = DateTime.now().difference(checkInTime!);
        });
        SessionService.save(workingDuration);
      });

      CustomDialog.show(
        context: context,
        title: "Check-In Success",
        message: "Your attendance has been marked successfully.",
        icon: Icons.check_circle,
        color: Colors.green,
      );

      setState(() {
        isCheckedIn = true;
        islocation = false;
        isImage = false;
        isLoading = false;
      });
      return;
    }

    final message = response["message"]?.toString() ?? "Check-in failed.";
    CustomDialog.show(
      context: context,
      title: "Check In",
      message: message,
      icon: Icons.error,
      color: Colors.red,
    );
    TopMessage.show(context, message, color: Colors.red);

    setState(() {
      isCheckedIn = false;
      islocation = false;
      isImage = false;
      isLoading = false;
    });
  }

  Future<void> checkOut() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      islocation = false;
      isImage = false;
      imagefile = null;
    });

    final location = await LocationHelper.getCurrentLocation();
    if (!mounted) return;

    if (location == null) {
      CustomDialog.show(
        context: context,
        title: "Location Required",
        message: "Enable GPS to continue attendance.",
        icon: Icons.location_off,
        color: Colors.orange,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      latitude = location["latitude"];
      longitude = location["longitude"];
      islocation = true;
    });

    TopMessage.show(context, "Location detected", color: Colors.green);

    await _captureFace();
    if (!mounted) return;

    if (!isImage || imagefile == null) {
      _showMissingFaceMessage();
      setState(() {
        isLoading = false;
        islocation = false;
      });
      return;
    }

    final response = await repository.checkoutData(
      imagefile!,
      latitude!,
      longitude!,
    );
    if (!mounted) return;

    if (response["success"] == true) {
      checkoutTime = DateTime.now();
      timer?.cancel();
      await SessionService.cleartime();
      if (!mounted) return;

      CustomDialog.show(
        context: context,
        title: "Check-Out Success",
        message: "Your attendance has been marked successfully.",
        icon: Icons.check_circle,
        color: Colors.green,
      );

      setState(() {
        workingDuration = Duration.zero;
        isCheckedIn = false;
        islocation = false;
        isImage = false;
        isLoading = false;
      });
      return;
    }

    final message = response["message"]?.toString() ?? "Check-out failed.";
    CustomDialog.show(
      context: context,
      title: "Check Out",
      message: message,
      icon: Icons.error,
      color: Colors.red,
    );
    TopMessage.show(context, message, color: Colors.red);

    setState(() {
      isLoading = false;
      islocation = false;
      isImage = false;
    });
  }

  Future<void> _captureFace() async {
    final File? image = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FaceCaptureView()),
    );

    if (image != null) {
      setState(() {
        isImage = true;
        imagefile = image;
      });

      print("Image path: ${image.path}");
    }
    //
  }

  void _showMissingFaceMessage() {
    CustomDialog.show(
      context: context,
      title: "Face Not Detected",
      message: "Please capture a clear selfie.",
      icon: Icons.error,
      color: Colors.red,
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: const EmployeeDrawer(),

      appBar: AppBar(
        title: const Text("HR Dashboard"),
        backgroundColor: const Color.fromARGB(255, 196, 204, 244),
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic here
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 73, 75, 70),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 12),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome HR 👋",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  "Manage your employees efficiently",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.access_time_filled,
                              color: Colors.white,
                              size: 20,
                            ),

                            SizedBox(width: 10),

                            Text(
                              "Have a productive day 🚀",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 184, 211, 233),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Working Hours",
                              style: TextStyle(
                                color: Color.fromARGB(255, 43, 37, 37),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 50),
                            Text(
                              "3h : 20m",
                              style: TextStyle(
                                color: Color.fromARGB(255, 43, 37, 37),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Text(
                              formatDuration(workingDuration),
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : SwipeableButtonView(
                                buttonText: isCheckedIn
                                    ? "Swipe to Check-Out"
                                    : "Swipe to Check-In",

                                buttonWidget: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey,
                                ),

                                activeColor: isCheckedIn
                                    ? Colors.red
                                    : Colors.green,

                                isFinished: isFinished,

                                onWaitingProcess: () {
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      setState(() {
                                        isFinished = true;
                                      });
                                    },
                                  );
                                },

                                onFinish: () async {
                                  isCheckedIn ? checkOut() : checkIn();

                                  setState(() {
                                    isFinished = false;
                                    isLoading = true;
                                  });
                                },
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// ================= STATS =================
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.25,

                  children: [
                    StatCard(
                      title: "Employees",
                      count: "120",
                      icon: Icons.people,
                      onPress: () => TopMessage.show(
                        context,
                        "this is the Employees ",
                        color: Colors.cyan,
                      ),
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
                  children: [
                    ActionButton(
                      icon: Icons.person_add,
                      label: "Add Employee",
                      onPressed: () => TopMessage.show(
                        context,
                        "Employee added successfully!",
                        color: Colors.green,
                      ),
                    ),
                    ActionButton(
                      icon: Icons.apartment,
                      label: "Department",
                      onPressed: () => TopMessage.show(
                        context,
                        "Department added successfully!",
                        color: Colors.green,
                      ),
                    ),
                    ActionButton(
                      icon: Icons.badge,
                      label: "Designation",
                      onPressed: () => TopMessage.show(
                        context,
                        "Designation added successfully!",
                        color: Colors.green,
                      ),
                    ),
                    ActionButton(
                      icon: Icons.campaign,
                      label: "Announcement",
                      onPressed: () => TopMessage.show(
                        context,
                        "Announcement added successfully!",
                        color: Colors.green,
                      ),
                    ),
                    ActionButton(
                      icon: Icons.schedule,
                      label: "Attendance",
                      onPressed: () => TopMessage.show(
                        context,
                        "Attendance updated successfully!",
                        color: Colors.green,
                      ),
                    ),
                    ActionButton(
                      icon: Icons.payments,
                      label: "Payroll",
                      onPressed: () => TopMessage.show(
                        context,
                        "Payroll processed successfully!",
                        color: Colors.green,
                      ),
                    ),
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

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.indigo.shade400],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: FloatingActionButton.extended(
          onPressed: () {
            context.push("/company/empcreate");
          },

          backgroundColor: Colors.transparent,
          elevation: 0,

          icon: const Icon(Icons.person_add_alt_1, color: Colors.white),

          label: const Text(
            "Add Employee",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
