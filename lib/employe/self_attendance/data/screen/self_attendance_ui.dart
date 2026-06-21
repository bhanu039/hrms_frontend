import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goexperts/core/widgets/dropdown_list.dart';
import 'package:intl/intl.dart';

import '../../bloc/self_attendance_bloc.dart';
import '../../bloc/self_attendance_event.dart';
import '../../bloc/self_attendance_state.dart';
import '../../data/attendance_model.dart';

class SelfAttendanceScreen extends StatefulWidget {
  const SelfAttendanceScreen({super.key});

  @override
  State<SelfAttendanceScreen> createState() => _SelfAttendanceScreenState();
}

class _SelfAttendanceScreenState extends State<SelfAttendanceScreen> {
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
          backgroundColor: const Color(0xFFF4F6FA),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'My Attendance',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildHeader(state),
              Expanded(child: _buildContent(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(SelfAttendanceState state) {
    return Container(
  width: double.infinity,
  // 1. Sleek, clean background with standard shadow layer definition
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 2. Clear visual header section hierarchy
      const Text(
        'Attendance Filters',
        style: TextStyle(
          fontSize: 16, 
          color: Color(0xFF111827),
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Summary for the selected period configuration parameters',
        style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
      ),
      
      const SizedBox(height: 20),
      
      // 3. Dynamic layout spacing framework mapping elements explicitly
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
              context.read<SelfAttendanceBloc>().add(AttendanceDateChanged(value));
            }),
          ),
          _buildFilterChip(
            width: 120,
            label: 'From',
            value: state.fromDate.isEmpty ? 'Start' : state.fromDate,
            onTap: () => _pickDate(context, state.fromDate, (value) {
              context.read<SelfAttendanceBloc>().add(AttendanceFromDateChanged(value));
            }),
          ),
          _buildFilterChip(
            label: 'To',
            width: 120,
            value: state.toDate.isEmpty ? 'End' : state.toDate,
            onTap: () => _pickDate(context, state.toDate, (value) {
              context.read<SelfAttendanceBloc>().add(AttendanceToDateChanged(value));
            }),
          ),
          AppDropdown(
            width: 120,
            label: 'Month',
            value: state.month,
            items: List.generate(12, (index) => (index + 1).toString()),
            
            onChanged: (value) {
              if (value != null) {
                context.read<SelfAttendanceBloc>().add(AttendanceMonthChanged(value));
              }
            },
          ),
          AppDropdown(
            label: 'Year',
            value: state.year,
            width: 120,
            items: List.generate(5, (index) => (DateTime.now().year - index).toString()),
           
            onChanged: (value) {
              if (value != null) {
                context.read<SelfAttendanceBloc>().add(AttendanceYearChanged(value));
              }
            },
          ),
          AppDropdown(
            width: 120,
            label: 'Status',
            value: state.status,
            items: const [
              'PRESENT', 'ABSENT', 'LEAVE', 'HALF_DAY', 
              'EARLY_EXIT', 'WEEK_OFF', 'PENDING_VERIFICATION', 'FUTURE'
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<SelfAttendanceBloc>().add(AttendanceStatusChanged(value));
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
                context.read<SelfAttendanceBloc>().add(AttendanceSortChanged(value));
              }
            },
          ),
        ],
      ),
  
      const SizedBox(height: 24),
      
      // 4. Clean bottom control deck (Moved out of Wrap layout completely to prevent shifting)
      Row(
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                context.read<SelfAttendanceBloc>().add(ApplyFilters());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB), // Premium Cobalt Blue
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {
                context.read<SelfAttendanceBloc>().add(ResetFilters());
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4B5563),
                side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Reset',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
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
          style: const TextStyle(color: Colors.red),
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
              color: Colors.grey.shade800,
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
        _statCard('Present', summary.present, Colors.green),
        _statCard('Absent', summary.absent, Colors.red),
        _statCard('Leave', summary.leaves, Colors.orange),
        _statCard('Half Days', summary.halfDays, Colors.purple),
        _statCard('Early Exit', summary.earlyExits, Colors.blue),
        _statCard('Week Offs', summary.weekOffs, Colors.teal),
        _statCard('Late', summary.late, Colors.amber),
      ],
    );
  }

  Widget _statCard(String label, int value, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
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
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12),
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
              style: const TextStyle(color: Colors.black87),
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
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
    double?width,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      
      onTap: onTap,
      child: Container(
        width: width??double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // Widget _buildDropdown({
  //   required String label,
  //   required String value,
  //   required List<String> items,
  //   required String hint,
  //   required ValueChanged<String?> onChanged,
  // }) {
  //   return SizedBox(
  //     width: 130,
  //     child: DropdownButtonFormField<String>(
  //       value: value.isEmpty ? null : value,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 12,
  //           vertical: 12,
  //         ),
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
  //         filled: true,
  //         fillColor: Colors.white,
  //       ),
  //       hint: Text(hint),
  //       items: [
  //         DropdownMenuItem(value: '', child: Text('Any $label')),
  //         ...items.map(
  //           (item) => DropdownMenuItem(value: item, child: Text(item)),
  //         ),
  //       ],
  //       onChanged: onChanged,
  //     ),
  //   );
  // }

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
        return Colors.green;
      case 'ABSENT':
        return Colors.red;
      case 'LEAVE':
        return Colors.orange;
      case 'HALF_DAY':
        return Colors.purple;
      case 'EARLY_EXIT':
        return Colors.indigo;
      case 'WEEK_OFF':
        return Colors.teal;
      case 'PENDING_VERIFICATION':
        return Colors.amber;
      case 'FUTURE':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }
}
