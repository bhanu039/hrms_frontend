import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goexperts/services/api_service.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../../widgets/Adding_Employee_Screen.dart';
import '../../widgets/custom_dailogbox.dart';
import '../../widgets/face_detact.dart';
import '../../widgets/location_get.dart';

import '../../widgets/top_message.dart';
import '../widgets/action_button.dart';
import '../widgets/small_info.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_tile.dart';
import 'hr_menu.dart';

class HrDashboardScreen extends StatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen> {
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

  Future<void> checkIn() async {
    // Get Location
    final location = await LocationHelper.getCurrentLocation();

    if (location != null) {
      setState(() {
        latitude = location["latitude"];
        longitude = location["latitude"];
        islocation = !islocation;
      });
      print("latitude>>>>>>>latitude>>>>>>$latitude,$longitude");
    }
    print("Latitude,Longitude>>>$latitude,$longitude");

    print("islocation---> $islocation");
    // Capture Face
    islocation
        ? await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FaceCaptureWidget(
                onCaptured: (File? image) {
                  if (image != null) {
                    setState(() {
                      isImage = !isImage;
                      imagefile = image;
                    });

                    print("Face detected ✔");
                    print(image.path);
                  } else {
                    CustomDialog.show(
                      context: context,
                      title: "face not detacted ",
                      message: "face not detacted ",
                      icon: Icons.pageview,
                      color: Colors.orange,
                    );
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ),
          )
        : {
            CustomDialog.show(
              context: context,
              title: "Location Required",
              message: "Enable GPS to continue attendance.",
              icon: Icons.location_off,
              color: Colors.orange,
            ),
            setState(() {
              isLoading = false;
            }),
          };

    if (isImage == true) {
      final apiService = ApiService();

      final response = await apiService.checkinData(
        imagefile!,
        latitude!,
        longitude!,
      );

      if (response["success"] == true) {
        print(response["data"]);

        print(response["data"]["message"]);

        CustomDialog.show(
          context: context,
          title: "Check-In Success",
          message: "Your attendance has been marked successfully.",
          icon: Icons.check_circle,
          color: Colors.green,
        );
        // Save Check-In Time
        checkInTime = DateTime.now();

        print(
          "Check-In Time: "
          "${checkInTime.toString().split('.').first}",
        );

        print("Latitude: $latitude");
        print("Longitude: $longitude");

        // Start Timer
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            workingDuration = DateTime.now().difference(checkInTime!);
          });
        });

        setState(() {
          isCheckedIn = !isCheckedIn;
          islocation = !islocation;
          isImage = !isImage;
          isLoading = !isLoading;
        });
      } else {
        CustomDialog.show(
          context: context,
          title: "Check In",
          message: "${response["message"]}",
          icon: Icons.error,
          color: Colors.red,
        );

        print(response["message"]);

        TopMessage.show(context, response["message"], color: Colors.red);
        setState(() {
          isLoading = !isLoading;
        });
      }
    } else {
      CustomDialog.show(
        context: context,
        title: "Face Not Detected",
        message: "Please capture a clear selfie.",
        icon: Icons.error,
        color: Colors.red,
      );
      setState(() {
        isLoading = !isLoading;
      });
    }
  }

  // =========================
  // CHECK OUT
  // =========================

  Future<void> checkOut() async {
    // Get Location
    final location = await LocationHelper.getCurrentLocation();

    if (location != null) {
      TopMessage.show(context, " location Detected", color: Colors.green);
      setState(() {
        latitude = location["latitude"];
        longitude = location["longitude"];
        islocation = !islocation;
      });
      print("latitude>>>>>>>longitude>>>>>>$latitude,$longitude");
    } else {
      TopMessage.show(
        context,
        "No location Detected",
        color: Colors.deepOrange,
      );
    }

    // Capture Face
    print("islocation---> $islocation");
    islocation
        ? await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FaceCaptureWidget(
                onCaptured: (File? image) {
                  if (image != null) {
                    setState(() {
                      isImage = !isImage;
                      isLoading = true;
                      imagefile = image;
                    });
                    CustomDialog.show(
                      context: context,
                      title: "face  detacted ",
                      message: "face  detacted ",
                      icon: Icons.pageview,
                      color: const Color.fromARGB(255, 45, 162, 60),
                    );

                    print("Face detected ✔");
                    print(image.path);
                  } else {
                    CustomDialog.show(
                      context: context,
                      title: "face not detacted ",
                      message: "face not detacted ",
                      icon: Icons.pageview,
                      color: Colors.orange,
                    );
                    setState(() {
                      isLoading = !isLoading;
                    });
                  }
                },
              ),
            ),
          )
        : CustomDialog.show(
            context: context,
            title: "Location Required",
            message: "Enable GPS to continue attendance.",
            icon: Icons.location_off,
            color: Colors.orange,
          );
    setState(() {
      isLoading = !isLoading;
    });

    if (isImage == true) {
      final apiService = ApiService();
      final response = await apiService.checkinData(
        imagefile!,
        latitude!,
        longitude!,
      );
      isLoading = !isLoading;

      if (response["success"] == true) {
        print(response["data"]);

        CustomDialog.show(
          context: context,
          title: "Check-Out Success",
          message: "Your attendance has been marked successfully.",
          icon: Icons.check_circle,
          color: Colors.green,
        );
        print(response["data"]["message"]);

        // Save Check-In Time
        checkoutTime = DateTime.now();

        print(
          "Check-Out Time: "
          "${checkoutTime.toString().split('.').first}",
        );

        print("Latitude: $latitude");
        print("Longitude: $longitude");

        timer?.cancel();

        setState(() {
          isLoading = !isLoading;
          islocation = !islocation;
          isImage = isImage;
          isCheckedIn = !isCheckedIn;
        });
      } else {
        CustomDialog.show(
          context: context,
          title: "Check Out",
          message: "${response["message"]}",
          icon: Icons.error,
          color: Colors.red,
        );

        print(response["message"]);
        setState(() {
          isLoading = false;
        });
        TopMessage.show(context, response["message"], color: Colors.red);
      }
    } else {
      TopMessage.show(context, "this is no image", color: Colors.red);
      CustomDialog.show(
        context: context,
        title: "Face Not Detected",
        message: "Please capture a clear selfie.",
        icon: Icons.error,
        color: Colors.red,
      );
      setState(() {
        isLoading = !isLoading;
      });
    }
  }

  // =========================
  // FORMAT TIMER
  // =========================

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);

    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  // =========================
  // DISPOSE
  // =========================

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      drawer: const HrDrawer(),

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
            );
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
