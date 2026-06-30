import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/state/auth/auth_bloc.dart';
import '../../../../core/widgets/custom_dailogbox.dart';
import '../../../../core/widgets/face_detact.dart';
import '../../../../core/widgets/location_get.dart';
import '../../../../core/widgets/swipe_checkIn_button.dart';
import '../../../../core/widgets/top_message.dart';
import '../../../../core/widgets/work_update.dart';
import '../../Screens/employee_menu.dart';
import '../bloc/emp_dashboard_bloc.dart';
import '../bloc/emp_dashboard_event.dart';
import '../bloc/emp_dashboard_state.dart';
import 'emp_dashborad_modal.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class EmpDashboardScreen extends StatefulWidget {
  const EmpDashboardScreen({super.key});

  @override
  State<EmpDashboardScreen> createState() => _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmpDashboardScreen> {
  final TextEditingController reasonController = TextEditingController();
  late String name;
  File? imagefile;
  String? workType;
  String? errorMessage;
  double? longitude;
  double? latitude;
  String? worktype;
  String? workDis;
  bool? isDailyWork;
  TimeOfDay? time;
  int? daytime;
  bool isreason = false;
  bool isCheckedIn = false;
  bool isCheckedOut = false;
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
        color: AppColors.red,
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
        color: AppColors.red,
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
        color: AppColors.red,
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
      print("Work Type: $workType, Description: $workDis");
    }
  }

  Future<void> _checkOut() async {
    setState(() {
      isLoading = true;
      iswork = false;
    });
    print("this is the isDailyWork >>>>>>>>>>>>>>>${time!.hour}>>>>");
    if (daytime != null && daytime! < 06) {
      await _showreasonDialog(context);
    } else if (daytime != null && daytime! >= 06) {
      isreason = true;
    }

    if (isreason) {
      if (!isDailyWork!) {
        await _workupdate();
      } else {
        setState(() {
          iswork = true;
        });
        CustomDialog.show(
          context: context,
          title: "Work  Updated Alredy",
          message: "Update Work.",
          icon: Icons.check_circle,
          color: AppColors.successColor,
        );
      }
    }
    if (iswork) {
      await location();
    } else {
      CustomDialog.show(
        context: context,
        title: "Work not Updated",
        message: "Please Update Work.",
        icon: Icons.error,
        color: AppColors.red,
      );
      return;
    }

    if (isImage) {
      context.read<EmpDashboardBloc>().add(
        CheckOutEvent(
          titile: workType,
          description: workDis,
          image: imagefile!,
          latitude: latitude!,
          longitude: longitude!,
          isDailyWork: isDailyWork!,
          reason: reasonController.text.trim(),
        ),
      );
    } else {
      CustomDialog.show(
        context: context,
        title: "face Not Detected",
        message: "Please capture a clear selfie.",
        icon: Icons.error,
        color: AppColors.red,
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
        setState(() {
          daytime = int.tryParse(hours) ?? 0;
        });

        yield "$hours:$minutes:$seconds";
      }
    } catch (_) {
      yield "00:00:00";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        backgroundColor: AppColors.surfaceElevated,
        foregroundColor: AppColors.textDark,
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
                  backgroundColor: AppColors.red,
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
              isCheckedIn = false;

              errorMessage = state.message;
            } else if (state is EmpDashboardLoaded) {
              d = state.dashboardData;
              isDailyWork = d.selfAttendance!.isDailyWork ?? false;

              isLoading = state.loading ?? false;
              errorBannerMessage = state.errorMessage;
              isCheckedIn = d.selfAttendance?.status ?? false;
              isCheckedOut = d.selfAttendance?.checkOutTime == null
                  ? false
                  : true;
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
                    color: AppColors.black.withOpacity(0.15),
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
        color: AppColors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.red.shade200),
      ),
      child: Row(
        children: [
           Icon(Icons.error_outline, color: AppColors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style:  TextStyle(
                color: AppColors.red,
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
        gradient:  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.tealBrand,
            AppColors.teal,
            AppColors.tealBrand,
          ], // Premium teal palette matching company uniform style
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withOpacity(0.25),
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
              backgroundColor: AppColors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: AppColors.white.withOpacity(0.03),
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
                      colors: [
                        AppColors.white.withOpacity(0.6),
                        AppColors.white.withOpacity(0.15),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.white.withOpacity(0.15),
                    child: ClipOval(
                      child: profileUrl != null && profileUrl.isNotEmpty
                          ? Image.network(
                              profileUrl,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildFallbackInitial(employeeName),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.white.withOpacity(0.8),
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
                          color: AppColors.white.withOpacity(0.75),
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
                          color: AppColors.white,
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
                              _buildInfoChip(
                                Icons.business_outlined,
                                department,
                              ),
                          ],
                        )
                      else
                        Text(
                          "Setup your employee profile details",
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.6),
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
        color: AppColors.white,
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
        color: AppColors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.white.withOpacity(0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.white.withOpacity(0.9)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkInCard(EmpDashboardModel d) {
    time = d.selfAttendance?.checkInTime != null
        ? TimeOfDay.fromDateTime(DateTime.parse(d.selfAttendance!.checkInTime!))
        : null;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: AppColors.black.withOpacity(0.06),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Check-In Time: ${time?.hour.toString().padLeft(2, '0')}:${time?.minute.toString().padLeft(2, '0')}",
                  style:  TextStyle(fontSize: 16, color: AppColors.black54),
                ),
                const SizedBox(height: 8),
                StreamBuilder(
                  stream: d.selfAttendance?.workingHours == null
                      ? liveWorkingTimer(d.selfAttendance?.checkInTime)
                      : Stream.value(d.selfAttendance?.workingHours),
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
                  isCheckedOut: isCheckedOut,
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
          _stat("Present", d.monthlyAttendance?.present ?? 0, AppColors.green),
          _stat("Absent", d.monthlyAttendance?.absent ?? 0, AppColors.red),
          _stat(
            "Rate",
            d.monthlyAttendance?.attendanceRate != null
                ? "${d.monthlyAttendance!.attendanceRate}%"
                : "0%",
            AppColors.blue,
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
          ?  Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No leave types recorded",
                style: TextStyle(color: AppColors.grey),
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
          ?  Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "No pending tasks",
                style: TextStyle(color: AppColors.grey),
              ),
            )
          : Column(
              children: items.map((e) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(e.label ?? "Action Item"),
                  trailing: CircleAvatar(
                    backgroundColor: AppColors.orange,
                    child: Text(
                      "${e.count ?? 0}",
                      style: const TextStyle(color: AppColors.white),
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: AppColors.black.withOpacity(0.05)),
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
          style:  TextStyle(color: AppColors.black54, fontSize: 13),
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
              title: const Text("Select Work Mode"),
              content: DropdownButtonFormField(
                value: selectedValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Select Work Mode",
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

  Future<void> _showreasonDialog(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reason for Checkout'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your reason here...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a reason';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                reasonController.clear();
                Navigator.of(context).pop(); // Closes the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  isreason = true;

                  String reason = reasonController.text.trim();
                  TopMessage.show(
                    context,
                    "Reason submitted: $reason",
                    color: AppColors.green,
                  );

                  reasonController.clear();
                  Navigator.of(context).pop(); // Closes the dialog
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}



