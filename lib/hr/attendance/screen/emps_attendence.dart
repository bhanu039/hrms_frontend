import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/state/auth/auth_bloc.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../../screens/hr_menu.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  State<EmployeeAttendanceScreen> createState() =>
      _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen> {
  String? myempId;

  final searchController = TextEditingController();

  @override
  void initState() {
    myempId = context.read<AuthBloc>().state.session?.id ?? "";

    context.read<AttendanceBloc>().add(AttendanceStarted());
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        final currentPage =
            state.attendanceResponse?.pagination.currentPage ?? 1;

        final totalPages = state.attendanceResponse?.pagination.totalPages ?? 1;

        final canGoNext = currentPage < totalPages;
        final canGoPrev = currentPage > 1;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          drawer: const HrDrawer(),

          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              "Attendance Dashboard",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed:(){
              context.push("/hr/attendance/self");
            },
                 // Pass your function here to navigate or open a modal
            elevation: 3,
            highlightElevation: 6,

            // Modern squircle shape matching premium dashboards
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.white24, width: 1),
            ),

            // Vibrant corporate blue palette for action-oriented visibility
            backgroundColor: const Color(0xFF2563EB), // Energetic Cobalt Blue
            foregroundColor: Colors.white,

            // Clean, contextual calendar attendance icon
            icon: const Icon(Icons.calendar_month_rounded, size: 20),

            label: const Text(
              "Check Attendance",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),

          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<AttendanceBloc>().add(AttendanceStarted());
              },
              child: Column(
                children: [
                  /// ================= SCROLLABLE CONTENT =================
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          /// ================= STATS =================
                          Row(
                            children: [
                              _statCard(
                                "Present",
                                state.attendanceResponse?.summary.present ?? 0,
                                Colors.green,
                                onTap: () {
                                  context.read<AttendanceBloc>().add(
                                    AttendanceStatusChanged("Present"),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              _statCard(
                                "Absent",
                                state.attendanceResponse?.summary.absent ?? 0,
                                Colors.red,
                                onTap: () {
                                  context.read<AttendanceBloc>().add(
                                    AttendanceStatusChanged("Absent"),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              _statCard(
                                "On Leave",
                                state.attendanceResponse?.summary.onLeave ?? 0,
                                Colors.orange,
                                onTap: () {
                                  context.read<AttendanceBloc>().add(
                                    AttendanceStatusChanged("Leave"),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              _statCard(
                                "Total",
                                state
                                        .attendanceResponse
                                        ?.summary
                                        .totalEmployees ??
                                    0,
                                Colors.blue,
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          /// ================= SEARCH =================
                          _searchBar(context),

                          const SizedBox(height: 12),

                          /// ================= FILTER =================
                          _filterBar(context, state),

                          const SizedBox(height: 16),

                          /// ================= LIST =================
                          state.isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      state
                                          .attendanceResponse
                                          ?.records
                                          .length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final e = state
                                        .attendanceResponse
                                        ?.records[index];

                                    return _employeeCard(e);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= PAGINATION (FIXED BOTTOM) =================
                  _paginationBar(
                    context,
                    currentPage,
                    totalPages,
                    canGoPrev,
                    canGoNext,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ================= STAT CARD =================
  Widget _statCard(
    String title,
    int count,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "$count",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= SEARCH =================
  Widget _searchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          hintText: "Search employee...",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
        onChanged: (v) {
          context.read<AttendanceBloc>().add(AttendanceSearchChanged(v));
        },
      ),
    );
  }

  /// ================= FILTER =================
  Widget _filterBar(BuildContext context, AttendanceState state) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: state.status.isEmpty ? null : state.status,
            decoration: _inputDecoration(),
            items: const [
              DropdownMenuItem(value: "All", child: Text("All")),
              DropdownMenuItem(value: "Present", child: Text("Present")),
              DropdownMenuItem(value: "Absent", child: Text("Absent")),
            ],
            onChanged: (v) {
              context.read<AttendanceBloc>().add(
                AttendanceStatusChanged(v ?? ""),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            context.read<AttendanceBloc>().add(ResetFilters());
          },
          child: const Text("Reset"),
        ),
      ],
    );
  }

  /// ================= EMPLOYEE CARD =================
  Widget _employeeCard(dynamic e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= TOP ROW =================
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(e?.checkInSelfie ?? ""),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e?.fullName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      e?.department ?? "",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              _statusChip(e?.status ?? ""),
            ],
          ),

          const SizedBox(height: 12),

          /// ================= DETAILS VERTICAL =================
          _infoRow("Check In", e?.checkIn ?? "--"),
          _infoRow("Check Out", e?.checkOut ?? "--"),
          _infoRow("Date", e?.date ?? "--"),
          _infoRow("Working Hours", e?.workingHours ?? "--"),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(": "),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = Colors.grey;

    if (status == "Present") color = Colors.green;
    if (status == "Absent") color = Colors.red;
    if (status == "Leave") color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: TextStyle(color: color)),
    );
  }

  /// ================= PAGINATION =================
  Widget _paginationBar(
    BuildContext context,
    int currentPage,
    int totalPages,
    bool canPrev,
    bool canNext,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Page $currentPage / $totalPages"),
          Row(
            children: [
              IconButton(
                onPressed: canPrev
                    ? () {
                        context.read<AttendanceBloc>().add(
                          LoadMoreEmployees(currentPage - 1),
                        );
                      }
                    : null,
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton(
                onPressed: canNext
                    ? () {
                        context.read<AttendanceBloc>().add(
                          LoadMoreEmployees(currentPage + 1),
                        );
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
