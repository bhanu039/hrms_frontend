import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/core/widgets/dropdown_list.dart';
import 'package:intl/intl.dart';

import '../../bloc/self_attendance_bloc.dart';
import '../../bloc/self_attendance_event.dart';
import '../../bloc/self_attendance_state.dart';
import '../attendance_model.dart';
import 'package:goexperts/core/app_constants/app_color.dart';

class SelfAttendanceScreen extends StatefulWidget {
  const SelfAttendanceScreen({super.key});

  @override
  State<SelfAttendanceScreen> createState() => _SelfAttendanceScreenState();
}

class _SelfAttendanceScreenState extends State<SelfAttendanceScreen> {
  bool _isFilterOpen = false;
  final dateController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SelfAttendanceBloc>().add(AttendanceStarted());
  }

  @override
  void dispose() {
    dateController.dispose();
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelfAttendanceBloc, SelfAttendanceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.white,
            title: const Text(
              'My Attendance',
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildHeader(context,state),
              Expanded(child: _buildContent(state)),
            ],
          ),
        );
      },
    );
  }
  Widget _buildHeader(BuildContext context, SelfAttendanceState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. CLICKABLE TOGGLE HEADER HEAD DECK ---
          InkWell(
            onTap: () {
              setState(() {
                _isFilterOpen = !_isFilterOpen;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: _isFilterOpen
                                  ? AppColors.info
                                  : AppColors.textDark,
                            ),
                            const SizedBox(width: 8),
                             Text(
                              'Attendance Filters',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                         Text(
                          'Configure parameter selections to query records',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Rotates or switches icon smoothly based on expand status
                  Icon(
                    _isFilterOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textMuted,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // --- 2. ANIMATED EXPANDABLE PANEL SECTION FRAME ---
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Divider(height: 1, color: AppColors.grey.shade300),
                  const SizedBox(height: 16),

                  // --- WRAP FIELD MATRIX ---
                  Wrap(
                    spacing: 12,
                    runSpacing: 14,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _buildFilterChip(
                        width: 120,
                        label: 'Date',
                        value: state.date.isEmpty ? 'Any' : state.date,
                        onTap: () => _pickDate(context, state.date, (value) {
                          context.read<SelfAttendanceBloc>().add(
                            AttendanceDateChanged(value),
                          );
                        }),
                      ),
                      _buildFilterChip(
                        width: 120,
                        label: 'From',
                        value: state.fromDate.isEmpty
                            ? 'Start'
                            : state.fromDate,
                        onTap: () =>
                            _pickDate(context, state.fromDate, (value) {
                              context.read<SelfAttendanceBloc>().add(
                                AttendanceFromDateChanged(value),
                              );
                            }),
                      ),
                      _buildFilterChip(
                        label: 'To',
                        width: 120,
                        value: state.toDate.isEmpty ? 'End' : state.toDate,
                        onTap: () => _pickDate(context, state.toDate, (value) {
                          context.read<SelfAttendanceBloc>().add(
                            AttendanceToDateChanged(value),
                          );
                        }),
                      ),
                      AppDropdown(
                        width: 120,
                        label: 'Month',
                        value: state.month,
                        items: List.generate(
                          12,
                          (index) => (index + 1).toString(),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<SelfAttendanceBloc>().add(
                              AttendanceMonthChanged(value),
                            );
                          }
                        },
                      ),
                      AppDropdown(
                        label: 'Year',
                        value: state.year,
                        width: 120,
                        items: List.generate(
                          5,
                          (index) => (DateTime.now().year - index).toString(),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<SelfAttendanceBloc>().add(
                              AttendanceYearChanged(value),
                            );
                          }
                        },
                      ),
                      AppDropdown(
                        width: 120,
                        label: 'Status',
                        value: state.status,
                        items: const [
                          'PRESENT',
                          'ABSENT',
                          'LEAVE',
                          'HALF_DAY',
                          'EARLY_EXIT',
                          'WEEK_OFF',
                          'PENDING_VERIFICATION',
                          'FUTURE',
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            context.read<SelfAttendanceBloc>().add(
                              AttendanceStatusChanged(value),
                            );
                          }
                        },
                      ),
                      AppDropdown(
                        width: 150,
                        label: 'Sort',
                        value: state.sort,
                        items: const ['asc', 'desc'],
                        onChanged: (value) {
                          if (value != null) {
                            context.read<SelfAttendanceBloc>().add(
                              AttendanceSortChanged(value),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- 3. UPDATED BUTTON CONTROL BAR (APPLY / CANCEL / RESET) ---
                  Row(
                    children: [
                      // Apply Actions Button
                      Expanded(
                        flex: 4,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<SelfAttendanceBloc>().add(
                              ApplyFilters(),
                            );
                            setState(
                              () => _isFilterOpen = false,
                            ); // CLoses panel on apply execution
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.info,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Cancel Action Button
                      Expanded(
                        flex: 3,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(
                              () => _isFilterOpen = false,
                            ); // Closes container explicitly without saving parameters
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.backgroundColor,
                            side:  BorderSide(
                              color: AppColors.accentBlue,
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Reset Control Action Button
                      IconButton(
                        onPressed: () {
                          context.read<SelfAttendanceBloc>().add(
                            ResetFilters(),
                          );
                        },
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: AppColors.danger,
                        ),
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(12),
                          backgroundColor: AppColors.dangerTint,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side:  BorderSide(color: AppColors.danger, width: 1.2),
                          ),
                        ),
                        tooltip: "Reset Parameters",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: _isFilterOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SelfAttendanceState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          state.errorMessage,
          style:  TextStyle(color: AppColors.red),
        ),
      );
    }

    if (state.attendanceResponse == null ||
        state.attendanceResponse!.history.isEmpty) {
      return const Center(child: Text('No attendance records found.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(state.attendanceResponse!.summary),
          const SizedBox(height: 18),
          Text(
            'Attendance history',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.grey.shade800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.attendanceResponse!.history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildHistoryCard(
                state.attendanceResponse!.history[index],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(SelfAttendanceSummary summary) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _statCard('Present', summary.present, AppColors.green),
        _statCard('Absent', summary.absent, AppColors.red),
        _statCard('Leave', summary.leaves, AppColors.orange),
        _statCard('Half Days', summary.halfDays, AppColors.purple),
        _statCard('Early Exit', summary.earlyExits, AppColors.blue),
        _statCard('Week Offs', summary.weekOffs, AppColors.teal),
        _statCard('Late', summary.late, AppColors.amber),
      ],
    );
  }

  Widget _statCard(String label, int value, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.grey.shade700, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(SelfAttendanceRecord record) {
    final statusColor = _statusColor(record.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.03), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat(
                    'EEE, MMM d',
                  ).format(DateTime.tryParse(record.date) ?? DateTime.now()),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  record.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _infoChip('Check-in', record.checkIn),
              const SizedBox(width: 8),
              _infoChip('Check-out', record.checkOut),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _infoChip('Hours', record.workingHours),
              const SizedBox(width: 8),
              _infoChip('Auto checkout', record.isAutoCheckout ? 'Yes' : 'No'),
            ],
          ),
          if (record.dailyWorkTitle != null ||
              record.dailyWorkSummary != null) ...[
            const SizedBox(height: 12),
            Text(
              record.dailyWorkTitle ?? 'Work summary',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              record.dailyWorkSummary ?? '-',
              style:  TextStyle(color: AppColors.black87),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoChip(String label, String? value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: AppColors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value ?? '—',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String value,
    double? width,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                color: AppColors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  //

  Future<void> _pickDate(
    BuildContext context,
    String initial,
    ValueChanged<String> onSelected,
  ) async {
    final initialDate = DateTime.tryParse(initial) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      onSelected(DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return AppColors.green;
      case 'ABSENT':
        return AppColors.red;
      case 'LEAVE':
        return AppColors.orange;
      case 'HALF_DAY':
        return AppColors.purple;
      case 'EARLY_EXIT':
        return AppColors.indigo;
      case 'WEEK_OFF':
        return AppColors.teal;
      case 'PENDING_VERIFICATION':
        return AppColors.amber;
      case 'FUTURE':
        return AppColors.blue;
      default:
        return AppColors.grey;
    }
  }
}



