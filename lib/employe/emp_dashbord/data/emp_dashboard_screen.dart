import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/auth/auth_bloc.dart';
import '../../../core/widgets/custom_dailogbox.dart';
import '../../../core/widgets/face_detact.dart';
import '../../../core/widgets/location_get.dart';
import '../../../core/widgets/swipe_checkIn_button.dart';
import '../../../core/widgets/work_update.dart';
import '../../Screens/employee_menu.dart';
import '../bloc/emp_dashboard_bloc.dart';
import '../bloc/emp_dashboard_event.dart';
import '../bloc/emp_dashboard_state.dart';
import 'emp_dashborad_modal.dart';

class EmpDashboardScreen extends StatefulWidget {
  const EmpDashboardScreen({super.key});

  @override
  State<EmpDashboardScreen> createState() => _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmpDashboardScreen> {
  late String name;
  File? imagefile;
  String? workType;
  bool condition = false;
  String? errorMessage;
  double? longitude;
  double? latitude;
  String? worktype;
  String? workDis;

  bool isCheckedIn = false;
  bool isFinished = false;
  bool isLoading = false;
  bool isLocation = false;
  bool isImage = false;
  bool iswork = false;

  Duration workingDuration = Duration.zero;

  @override
  void initState() {
    name = context.read<AuthBloc>().state.session?.name ?? "EMPLOYEE";
    context.read<EmpDashboardBloc>().add(EmpLoadDashboard());
    super.initState();
  }

  Future<void> _refresh() async {
    context.read<EmpDashboardBloc>().add(EmpLoadDashboard());
  }

  Future<void> _checkIn() async {
    await showReasonDialog(context);
    if (workType != null) {
      await location();
    } else {
      CustomDialog.show(
        context: context,
        title: "Work Type",
        message: "Please Select work type.",
        icon: Icons.error,
        color: Colors.red,
      );
      return;
    }

    if (isImage) {
      context.read<EmpDashboardBloc>().add(
        CheckInEvent(
          image: imagefile!,
          latitude: latitude!,
          longitude: longitude!,
          mode: workType!,
        ),
      );
    } else {
      CustomDialog.show(
        context: context,
        title: "face Not Detected",
        message: "Please capture a clear selfie.",
        icon: Icons.error,
        color: Colors.red,
      );
    }
  }

  Future<void> facecapture() async {
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
    setState(() => isCheckedIn = false);
  }

  Future<void> location() async {
    final location = await LocationHelper.getCurrentLocation();

    setState(() {
      latitude = location?["latitude"];
      longitude = location?["longitude"];
      isLocation = true;
    });

    if (isLocation) {
      await facecapture();
    } else {
      CustomDialog.show(
        context: context,
        title: "Location Not Detected",
        message: "Please capture a clear selfie.",
        icon: Icons.error,
        color: Colors.red,
      );
    }
  }

  Future<void> _workupdate() async {
    final work = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WorkSubmissionScreen()),
    );
    if (work != null) {
      setState(() {
        iswork = true;
        workType = work["title"];
        workDis = work["description"];
      });
    }
  }

  Future<void> _checkOut() async {
    await _workupdate();
    if (iswork) {
      await location();
    } else {
      CustomDialog.show(
        context: context,
        title: "Work not Updated",
        message: "Please Update Work.",
        icon: Icons.error,
        color: Colors.red,
      );
      return;
    }

    if (isImage) {
      context.read<EmpDashboardBloc>().add(
        CheckOutEvent(
          image: imagefile!,
          latitude: latitude!,
          longitude: longitude!,
        ),
      );
    } else {
      CustomDialog.show(
        context: context,
        title: "face Not Detected",
        message: "Please capture a clear selfie.",
        icon: Icons.error,
        color: Colors.red,
      );
    }
    setState(() => isCheckedIn = false);
  }

  Stream<String> liveWorkingTimer(String? checkInTime) async* {
    if (checkInTime == null || checkInTime.isEmpty) {
      yield "00:00:00";
      return;
    }
    try {
      final checkIn = DateTime.parse(checkInTime).toLocal();
      while (true) {
        await Future.delayed(const Duration(seconds: 1));
        final duration = DateTime.now().difference(checkIn);
        final hours = duration.inHours.toString().padLeft(2, '0');
        final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
        yield "$hours:$minutes:$seconds";
      }
    } catch (_) {
      yield "00:00:00";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        backgroundColor: const Color.fromARGB(255, 187, 195, 240),
        actions: const [Icon(Icons.notifications), SizedBox(width: 12)],
      ),
      drawer: const EmployeeDrawer(),
      body: SafeArea(
        child: BlocConsumer<EmpDashboardBloc, EmpDashboardState>(
          listener: (context, state) {
            if (state is EmpDashboardError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            EmpDashboardModel d = EmpDashboardModel();
            bool isDashboardLoading = false;
            String? errorBannerMessage;

            if (state is EmpDashboardLoading) {
              isDashboardLoading = true;
            } else if (state is EmpDashboardError) {
              errorBannerMessage = state.message;
              isCheckedIn = false;
            } else if (state is EmpDashboardLoaded) {
              d = state.dashboardData;
              isDashboardLoading = state.loading ?? false;
              errorBannerMessage = state.errorMessage;
              isCheckedIn = d.selfAttendance?.status ?? false;
            }

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (errorBannerMessage != null)
                          _errorAlertBanner(errorBannerMessage),
                        _header(d),
                        const SizedBox(height: 16),
                        _checkInCard(d),
                        const SizedBox(height: 16),
                        _attendanceCard(d),
                       
                        const SizedBox(height: 16),
                        _pendingActions(d),
                         const SizedBox(height: 16),
                        _leaveBalance(d),
                      ],
                    ),
                  ),
                ),
                if (isDashboardLoading)
                  Container(
                    color: Colors.black.withOpacity(0.15),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /* ---------------- UI MODULES WITH NULL SAFETY & INLINE ERROR HANDLING ---------------- */

  Widget _errorAlertBanner(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _header(EmpDashboardModel d) {
  final employeeName = d.employee?.name ?? "Employee";
  final designation = d.employee?.designation;
  final department = d.employee?.department;
  final profileUrl = d.employee?.profilePhoto; // Mapping backend URL
  final hasJobInfo = designation != null || department != null;

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F766E), Color(0xFF115E59), Color(0xFF134E4A)], // Premium teal palette matching company uniform style
        stops: [0.0, 0.5, 1.0],
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF115E59).withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Stack(
      children: [
        // Background Decorative Abstract Glass Ring Shapes
        Positioned(
          right: -25,
          top: -25,
          child: CircleAvatar(
            radius: 75,
            backgroundColor: Colors.white.withOpacity(0.05),
          ),
        ),
        Positioned(
          left: -40,
          bottom: -40,
          child: CircleAvatar(
            radius: 90,
            backgroundColor: Colors.white.withOpacity(0.03),
          ),
        ),
        
        // Main Content Row Layout
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Profile Photo Container with Neon Frame Line Action
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.6), Colors.white.withOpacity(0.15)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: ClipOval(
                    child: profileUrl != null && profileUrl.isNotEmpty
                        ? Image.network(
                            profileUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildFallbackInitial(employeeName),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              );
                            },
                          )
                        : _buildFallbackInitial(employeeName),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Text and Label Block Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome Back, 👋",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      employeeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Styled Adaptive Information Badges
                    if (hasJobInfo)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (designation != null && designation.isNotEmpty)
                            _buildInfoChip(Icons.work_outline, designation),
                          if (department != null && department.isNotEmpty)
                            _buildInfoChip(Icons.business_outlined, department),
                        ],
                      )
                    else
                      Text(
                        "Setup your employee profile details",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Generates text initial when URL path is missing or broken
Widget _buildFallbackInitial(String name) {
  return Text(
    name.isNotEmpty ? name.trim().substring(0, 1).toUpperCase() : "E",
    style: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  );
}

// Inner helper chip utility method
Widget _buildInfoChip(IconData icon, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.12),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: Colors.white.withOpacity(0.15),
        width: 1,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Colors.white.withOpacity(0.9)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}



  Widget _checkInCard(EmpDashboardModel d) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.06)),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Check-In Time: ${d.selfAttendance?.checkInTime ?? "---"}",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: liveWorkingTimer(d.selfAttendance?.checkInTime),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? "00:00:00",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          SwipeCheckInButton(
            isCheckedIn: isCheckedIn,
            onCheckIn: () async {
              setState(() {
                isLoading = true;
                isLocation = false;
                isImage = false;
                imagefile = null;
              });
              await _checkIn();
            },
            onCheckOut: () async {
              setState(() {
                isLoading = true;
                isLocation = false;
                isImage = false;
                imagefile = null;
              });
              await _checkOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _attendanceCard(EmpDashboardModel d) {
    return _card(
      title: "Monthly Attendance",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stat("Present", d.monthlyAttendance?.present ?? 0, Colors.green),
          _stat("Absent", d.monthlyAttendance?.absent ?? 0, Colors.red),
          _stat(
            "Rate",
            d.monthlyAttendance?.attendanceRate != null
                ? "${d.monthlyAttendance!.attendanceRate}%"
                : "0%",
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _leaveBalance(EmpDashboardModel d) {
    final list = d.leaveBalance ?? [];
    return _card(
      title: "Leave Balance",
      child: list.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No leave types recorded",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: list.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.type ?? "Unknown Leave Type",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${e.remaining ?? 0}/${e.total ?? 0}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _pendingActions(EmpDashboardModel d) {
    final items = d.pendingActions?.items ?? [];
    return _card(
      title: "Pending Actions",
      child: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No pending tasks",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              children: items.map((e) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(e.label ?? "Action Item"),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(
                      "${e.count ?? 0}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _stat(String title, dynamic value, Color color) {
    return Column(
      children: [
        Text(
          "$value",
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }

  Future showReasonDialog(BuildContext context) async {
    String? selectedValue;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Reason"),
              content: DropdownButtonFormField(
                value: selectedValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Choose Reason",
                ),
                items: const [
                  DropdownMenuItem(value: "WFH", child: Text("Work From Home")),
                  DropdownMenuItem(
                    value: "WFO",
                    child: Text("Work From Office"),
                  ),
                  DropdownMenuItem(
                    value: "Field Work",
                    child: Text("Field Work"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    workType = selectedValue;
                    Navigator.pop(context);
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
