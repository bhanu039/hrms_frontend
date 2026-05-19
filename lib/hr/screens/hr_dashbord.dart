import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goexperts/services/api_service.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

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
  File? employeePhoto;

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
    await getCurrentLocation();
    print("Latitude,Longitude>>>$latitude,$longitude");

    print("islocation---> $islocation");
    // Capture Face
    islocation
        ? await captureFace()
        : TopMessage.show(context, "image will not capure", color: Colors.red);

    if (isImage == true) {
      final apiService = ApiService();

      final response = await apiService.checkinData(
        employeePhoto!,
        latitude!,
        longitude!,
      );

      if (response["success"] == true) {
        print(response["data"]);

        print(response["data"]["message"]);

        TopMessage.show(context, "Your Checkin success ", color: Colors.green);

        // Save Check-In Time
        checkInTime = DateTime.now();

        print(
          "Check-In Time: "
          "${checkInTime.toString().split('.').first}",
        );

        print("Latitude: $latitude");
        print("Longitude: $longitude");

        isCheckedIn = true;

        // Start Timer
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            workingDuration = DateTime.now().difference(checkInTime!);
          });
        });

        setState(() {
          islocation == false;
          isImage = false;
        });
      } else {
        print(response["message"]);

        TopMessage.show(context, response["message"], color: Colors.red);
      }
    }
  }

  // =========================
  // CHECK OUT
  // =========================

  Future<void> checkOut() async {
    // Get Location
    await getCurrentLocation();

    // Capture Face
    print("islocation---> $islocation");
    islocation
        ? await captureFace()
        : TopMessage.show(context, "image will not capure", color: Colors.red);

    if (isImage == true) {
      final apiService = ApiService();
      final response1 = await apiService.checkinData(
        employeePhoto!,
        latitude!,
        longitude!,
      );

      if (response1["success"] == true) {
        print(response1["data"]);

        TopMessage.show(context, "Your CheckOut success ", color: Colors.green);

        print(response1["data"]["message"]);

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
          islocation = false;
          isImage = false;
          isCheckedIn = false;
        });
      } else {
        print(response1["message"]);
        TopMessage.show(context, response1["message"], color: Colors.red);
      }
    }
  }

  apicalls() async {}

  // =========================
  // GET LOCATION
  // =========================

  Future<void> getCurrentLocation() async {
    // System permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Permission denied");
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    print(position.latitude);
    print(position.longitude);

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      islocation = true;
    });
    print("islocation---> $islocation");
  }
  // =========================
  // CAPTURE FACE
  // =========================

  Future<void> captureFace() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile == null) return;

    employeePhoto = File(pickedFile.path);

    bool hasFace = await detectFace(employeePhoto!);

    if (!hasFace) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No Face Detected")));
      isImage = false;

      return;
    } else {
      setState(() {
        isImage = true;
      });
    }
  }

  // =========================
  // FACE DETECTION
  // =========================

  Future<bool> detectFace(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);

    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableContours: true, enableLandmarks: true),
    );

    final faces = await faceDetector.processImage(inputImage);

    await faceDetector.close();

    return faces.isNotEmpty;
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
                    color: const Color.fromARGB(255, 184, 211, 233),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Working Hours",
                        style: TextStyle(
                          color: Color.fromARGB(255, 43, 37, 37),
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        formatDuration(workingDuration),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: isCheckedIn ? checkOut : checkIn,

                        child: Text(isCheckedIn ? "Check-Out" : "Check-In"),
                      ),
                    ],
                  ),
                ),

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
    );
  }
}
