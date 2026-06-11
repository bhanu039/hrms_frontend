import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/attendance_model.dart';
import '../../widgets/attendance_Card.dart';

import '../../widgets/date_widget.dart';
import '../../widgets/stat_card.dart';
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
  final searchController = TextEditingController();
  final fromdateController = TextEditingController();
  final todateController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    fromdateController.dispose();
    todateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceBloc()..add(AttendanceStarted()),

      child: Scaffold(
        drawer: const HrDrawer(),
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Employee Attendance",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            final currentPage =
                state.attendanceResponse?.pagination.currentPage ?? 1;

            final totalPages =
                state.attendanceResponse?.pagination.totalPages ?? 1;

            final canLoadMore = currentPage < totalPages;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Present",
                          count:
                              state.attendanceResponse?.summary.present
                                  .toString() ??
                              '0',
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: "Absent",
                          count:
                              state.attendanceResponse?.summary.absent
                                  .toString() ??
                              '0',
                          icon: Icons.cancel_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "onLeave",
                          count:
                              state.attendanceResponse?.summary.onLeave
                                  .toString() ??
                              '0',
                          icon: Icons.access_time,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: "Total",
                          count:
                              state.attendanceResponse?.summary.totalEmployees
                                  .toString() ??
                              '0',
                          icon: Icons.people_alt_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      TextField(
                        controller: searchController,
                        onChanged: (value) {
                          context.read<AttendanceBloc>().add(
                            AttendanceSearchChanged(value),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "Search employee...",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: state.search.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    context.read<AttendanceBloc>().add(
                                      AttendanceSearchChanged(
                                        searchController.text,
                                      ),
                                    );
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      DateFieldWidget(
                        label: 'Attendance start Date',
                        controller: fromdateController,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );

                          if (date != null) {
                            fromdateController.text =
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                            context.read<AttendanceBloc>().add(
                              ToDateChanged(fromdateController.text),
                            );
                          }
                        },
                        onClear: () {
                          fromdateController.clear();

                          context.read<AttendanceBloc>().add(ToDateChanged(''));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: state.status.isEmpty
                              ? null
                              : state.status,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "All",
                              child: Text("All Status"),
                            ),
                            DropdownMenuItem(
                              value: "Present",
                              child: Text("Present"),
                            ),
                            DropdownMenuItem(
                              value: "Absent",
                              child: Text("Absent"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            context.read<AttendanceBloc>().add(
                              AttendanceStatusChanged(value),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download),
                        label: const Text("Export"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      currentPage != 1
                          ? ElevatedButton(
                              onPressed: canLoadMore
                                  ? () {
                                      context.read<AttendanceBloc>().add(
                                        LoadMoreEmployees(
                                          currentPage: currentPage - 1,
                                        ),
                                      );
                                    }
                                  : null,
                              child: const Text('Previous'),
                            )
                          : const Text('no previous page'),

                      const SizedBox(width: 20),

                      Text('Page $currentPage of $totalPages'),

                      const SizedBox(width: 20),

                      currentPage == totalPages
                          ? const Text('no next page')
                          : ElevatedButton(
                              onPressed: canLoadMore
                                  ? () {
                                      context.read<AttendanceBloc>().add(
                                        LoadMoreEmployees(
                                          currentPage: currentPage + 1,
                                        ),
                                      );
                                    }
                                  : null,
                              child: const Text('Next'),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  attendanceHeader(),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.attendanceResponse?.records.length ?? 0,
                    itemBuilder: (context, index) {
                      final employee = state.attendanceResponse?.records[index];

                      return attendanceCard(

                        pic:employee?.checkInSelfie??'',
                        name: employee?.fullName ?? '',
                        department: employee?.department ?? '',
                        status: employee?.status ?? '',
                        checkIn: employee?.checkIn ?? '--',
                        onTap: () => {



                        },


                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget attendanceHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    color: Colors.grey.shade200,
    child: const Row(
      children: [
        SizedBox(width: 40, child: Text("IMG", style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 20),
        SizedBox(width: 80, child: Text("NAME", style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 20),
        SizedBox(width: 80, child: Text("DEPT", style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 20),
        SizedBox(width: 80, child: Text("STATUS", style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 20),
        SizedBox(width: 70, child: Text("IN", style: TextStyle(fontWeight: FontWeight.bold))),
        SizedBox(width: 20),
        SizedBox(width: 70, child: Text("OUT", style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    ),
  );
}
}
