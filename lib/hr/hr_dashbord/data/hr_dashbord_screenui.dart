import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/auth/auth_bloc.dart';
import '../../../core/widgets/face_detact.dart';
import '../../../core/widgets/location_get.dart';
import '../../../core/widgets/swipe_checkIn_button.dart';
import '../../../core/widgets/work_update.dart';
import '../../screens/hr_menu.dart';
import '../bloc/hr_dashbord_bloc.dart';
import '../bloc/hr_dashbord_state.dart';
import '../bloc/hr_dashbords_event.dart';
import 'hr_dashbord_modal.dart';
import 'package:goexperts/core/widgets/custom_dailogbox.dart';

class HrDashboardScreen extends StatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen> {
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
        name = context.read<AuthBloc>().state.session?.name ?? "HR";

    context.read<HrDashboardBloc>().add(LoadHrDashboard());
    super.initState();

  }

  Future<void> _refresh() async {
    context.read<HrDashboardBloc>().add(LoadHrDashboard());
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
        ? context.read<HrDashboardBloc>().add(
            CheckInRequested(
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
    setState(() => isCheckedIn = true);
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
    iswork ?await location():CustomDialog.show(
            context: context,
            title: "Work not Updated",
            message: "Please Update Work.",
            icon: Icons.error,
            color: Colors.red,
          );

    isImage
        ? context.read<HrDashboardBloc>().add(
            CheckOutRequested(
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
        title: const Text("HR Dashboard"),
        backgroundColor: const Color.fromARGB(255, 166, 169, 186),
        actions: const [Icon(Icons.notifications), SizedBox(width: 12)],
      ),

      drawer: const HrDrawer(),

      body: SafeArea(
        child: BlocBuilder<HrDashboardBloc, HrDashboardState>(
          builder: (context, state) {
            HrDashboardModel? d;
            if (state is HrDashboardError) {
            
              condition = false;
              isCheckedIn = false;

              errorMessage = state.message;
              d = HrDashboardModel(kpis: null);
            }

            if (state is HrDashboardLoaded) {

             errorMessage=state.errorMessage;
             isLoading=state.loading!;
              condition = true;
              d = state.dashboardData;
              isCheckedIn = d.selfAttendance?.status ?? false;
            }

            if (state is HrDashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _welcomeCard(),

                    if (errorMessage != null) _errorBox(),

                    const SizedBox(height: 10),

                    if (d != null) ...[
                      _checkInCard(d),

                      const SizedBox(height: 12),
                      _kpiGrid(d),

                      const SizedBox(height: 12),

                      _attendanceCard(d),

                      const SizedBox(height: 12),

                      _workModeChart(d),

                      const SizedBox(height: 12),

                      _pendingActions(d),

                      const SizedBox(height: 12),

                      _recentActivity(d),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          condition
              ? context.push("/company/empcreate")
              : CustomDialog.show(
                  context: context,
                  title: "Permission",
                  message: errorMessage ?? "No access",
                  icon: Icons.error,
                  color: Colors.red,
                );
        },
        icon: const Icon(Icons.person_add),
        label: const Text("Add Employee"),
      ),
    );
  }

  // ---------------- WELCOME ----------------
  Widget _welcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.indigo, Colors.blue]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "Welcome $name 👋",
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  // ---------------- ERROR SAFE ----------------
  Widget _errorBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        errorMessage ?? "",
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  // ---------------- CHECK IN OUT ----------------
  Widget _checkInCard(HrDashboardModel d) {
    return isLoading?const Center(child: CircularProgressIndicator()):Container(
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
            "Check_In_Time:    ${d.selfAttendance?.checkInTime ?? "--"}  ",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<String>(
            stream: liveWorkingTimer(d.selfAttendance?.checkInTime ?? "--"),
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
            isCheckedIn: isCheckedIn!,
            onCheckIn: () async {
             
              _checkIn();
            },
            onCheckOut: () async {
              
              _checkOut();
            },
          ),
        ],
      ),
    );
  }

  // ---------------- KPI GRID (3 + 2 CENTER FIX) ----------------
  Widget _kpiGrid(HrDashboardModel d) {
    final items = [
      _kpi("Employees", "${d.kpis?.totalEmployees?.value ?? ""}", Colors.blue),
      _kpi("Projects", "${d.kpis?.totalProjects?.value ?? ""}", Colors.green),
      _kpi(
        "Attendance",
        "${d.kpis?.attendanceRate?.value ?? ""}%",
        Colors.orange,
      ),
      _kpi("Leave", "${d.kpis?.onLeaveToday?.value ?? ""}", Colors.red),
      _kpi("Payroll", "${d.kpis?.payrollDue?.formatted}", Colors.purple),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        double width = c.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(items.length, (i) {
            double itemWidth = (width - 24) / 3;

            if (i >= 3) {
              itemWidth = (width - 12) / 2;
            }

            return SizedBox(width: itemWidth, child: items[i]);
          }),
        );
      },
    );
  }

  Widget _kpi(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _baseCard({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        // ⭐ modern subtle border
        border: Border.all(color: const Color(0xFFEDEDED), width: 1),

        // ⭐ premium soft shadow (modern UI standard)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: child,
    );
  }

  /// ---------------- ATTENDANCE ----------------
  Widget _attendanceCard(HrDashboardModel d) {
    final a = d.todaysAttendance?.breakdown;

    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Attendance",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _attBox("Present", a?.present ?? 0, Colors.green),
              _attBox("Absent", a?.absent ?? 0, Colors.red),
              _attBox("Leave", a?.onLeave ?? 0, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attBox(String label, int value, Color color) {
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
          label,
          style: const TextStyle(color: Color.fromARGB(153, 7, 7, 7)),
        ),
      ],
    );
  }

  Widget _workModeChart(HrDashboardModel d) {
    final work = d.charts?.workModelSplit;

    final wfo = (work?.wfo ?? 40);
    final wfh = (work?.wfh ?? 35);
    final hybrid = (work?.hybrid ?? 25);

    // ensure total = 100 visually safe
    final total = (wfo + wfh + hybrid).toDouble();

    double percent(int value) {
      return total == 0 ? 0 : (value / total);
    }

    return _baseCard(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 246, 236, 236),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Work Mode Distribution",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _workBar("WFO", wfo, percent(wfo), Colors.blue),
            const SizedBox(height: 12),

            _workBar("WFH", wfh, percent(wfh), Colors.green),
            const SizedBox(height: 12),

            _workBar("Hybrid", hybrid, percent(hybrid), Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _workBar(String label, int value, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Color.fromARGB(179, 107, 0, 0)),
            ),
            Text(
              "${value.toString()}%",
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(20), // 👈 fully rounded
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 10,
            backgroundColor: const Color.fromARGB(26, 72, 59, 59),
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _pendingActions(HrDashboardModel d) {
    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pending Actions",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
          ),

          const SizedBox(height: 10),

          ...(d.pendingActions?.items ?? []).map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    e.label ?? "",
                    style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                  ),
                  Text(
                    "${e.count ?? 0}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 45, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentActivity(HrDashboardModel d) {
    return _baseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Activity",
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
          ),

          const SizedBox(height: 10),

          ...(d.recentActivity ?? []).map(
            (e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title ?? "",
                    style: const TextStyle(
                      color: Color.fromARGB(179, 14, 7, 7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    e.type ?? "",
                    style: const TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                    value: "WFO",
                    child: Text("Work From Office"),
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

