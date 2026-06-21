import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

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
    super.initState();
    name = context.read<AuthBloc>().state.session?.name ?? "HR";

    context.read<EmpDashboardBloc>().add(EmpLoadDashboard());
  }

  Future<void> _refresh() async {
    context.read<EmpDashboardBloc>().add(EmpLoadDashboard());
  }

  Future<void> _checkIn() async {
    await showReasonDialog(context);
    workType != null
        ? await location()
        : CustomDialog.show(
            context: context,
            title: "Work Type",
            message: "Please Select work type .",
            icon: Icons.error,
            color: Colors.red,
          );
    isImage
        ? context.read<EmpDashboardBloc>().add(
            CheckInEvent(
              image: imagefile!,
              latitude: latitude!,
              longitude: longitude!,
              mode: workType!,
            ),
          )
        : CustomDialog.show(
            context: context,
            title: "face Not Detected",
            message: "Please capture a clear selfie.",
            icon: Icons.error,
            color: Colors.red,
          );
   
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
    isLocation
        ? await facecapture()
        : CustomDialog.show(
            context: context,
            title: "Location Not Detected",
            message: "Please capture a clear selfie.",
            icon: Icons.error,
            color: Colors.red,
          );
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
    iswork
        ? await location()
        : CustomDialog.show(
            context: context,
            title: "Work not Updated",
            message: "Please Update Work.",
            icon: Icons.error,
            color: Colors.red,
          );

    isImage
        ? context.read<EmpDashboardBloc>().add(
            CheckOutEvent(
              image: imagefile!,
              latitude: latitude!,
              longitude: longitude!,
            ),
          )
        : CustomDialog.show(
            context: context,
            title: "face Not Detected",
            message: "Please capture a clear selfie.",
            icon: Icons.error,
            color: Colors.red,
          );
    setState(() => isCheckedIn = false);
  }

  Stream<String> liveWorkingTimer(String? checkInTime) async* {
    if (checkInTime == null || checkInTime.isEmpty) {
      yield "00:00:00";
      return;
    }

    final checkIn = DateTime.parse(checkInTime).toLocal();

    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      final duration = DateTime.now().difference(checkIn);

      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

      yield "$hours:$minutes:$seconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Employee Dashboard"),
        backgroundColor: const Color.fromARGB(255, 166, 169, 186),
        actions: const [Icon(Icons.notifications), SizedBox(width: 12)],
      ),

      drawer: const EmployeeDrawer(),

      body: SafeArea(
        child: BlocBuilder<EmpDashboardBloc, EmpDashboardState>(
          builder: (context, state) {
            EmpDashboardModel? d;
        
            if (state is EmpDashboardError) {
            
              condition = false;
              isCheckedIn = false;

              errorMessage = state.message;
              d = EmpDashboardModel(employee: null);
            }

            if (state is EmpDashboardLoaded) {

             errorMessage=state.errorMessage;
             isLoading=state.loading!;
              condition = true;
              d = state.dashboardData;
              isCheckedIn = d.selfAttendance?.status ?? false;
            }

            if (state is EmpDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// 👤 HEADER
                      if (d != null) ...[
                        _header(d),

                        const SizedBox(height: 16),

                        /// ⏱ CHECK IN / OUT
                        _checkInCard(d),

                        const SizedBox(height: 16),

                        /// 📊 MONTHLY ATTENDANCE
                        _attendanceCard(d),

                        const SizedBox(height: 16),

                        /// 💰 LEAVE BALANCE
                        _leaveBalance(d),

                        const SizedBox(height: 16),

                        /// 📌 PENDING ACTIONS
                        _pendingActions(d),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /* ---------------- HEADER ---------------- */
  Widget _header(EmpDashboardModel d) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 26, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d.employee?.name ?? "name",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${d.employee?.designation} • ${d.employee?.department}",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
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
            "Check_In_Time:    ${d.selfAttendance?.checkInTime ?? "---"}",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          StreamBuilder<String>(
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

              _checkIn();
            },
            onCheckOut: () async {
              setState(() {
                isLoading = true;
                isLocation = false;
                isImage = false;
                imagefile = null;
              });

              _checkOut();
            },
          ),
        ],
      ),
    );
  }

  /* ---------------- ATTENDANCE ---------------- */
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
            "${d.monthlyAttendance?.attendanceRate ?? 0}%",
            Colors.blue,
          ),
        ],
      ),
    );
  }

  /* ---------------- LEAVE BALANCE ---------------- */
  Widget _leaveBalance(EmpDashboardModel d) {
    final list = d.leaveBalance ?? [];

    return _card(
      title: "Leave Balance",
      child: Column(
        children: list.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.type ?? "Unknown"),
                Text("${e.remaining ?? 0}/${e.total ?? 0}"),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /* ---------------- PENDING ---------------- */
  Widget _pendingActions(EmpDashboardModel d) {
    final items = d.pendingActions?.items ?? [];

    return _card(
      title: "Pending Actions",
      child: Column(
        children: items.map((e) {
          return ListTile(
            title: Text(e.label ?? ""),
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

  /* ---------------- COMMON CARD ---------------- */
  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
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
        Text(title),
      ],
    );
  }

  Future<void> showReasonDialog(BuildContext context) async {
    String? selectedValue;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Reason"),
              content: DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Choose Reason",
                ),
                items: const [
                  DropdownMenuItem(value: "WFH", child: Text("Work From Home")),
                  DropdownMenuItem(
                    value: "WFH",
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
                    print(selectedValue);

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
