import '../data/hr_dashbord_modal.dart';

/// ================= MAIN STATE =================
abstract class HrDashboardState {
  const HrDashboardState();
}

/// ================= DASHBOARD =================
class HrDashboardInitial extends HrDashboardState {}

class HrDashboardLoading extends HrDashboardState {}

class HrDashboardError extends HrDashboardState {
  final String message;

  const HrDashboardError(this.message);
}

class HrDashboardLoaded extends HrDashboardState {
  final HrDashboardModel data;

  const HrDashboardLoaded(this.data);
}

/// ================= ATTENDANCE STATUS =================
enum AttendanceStatus {
  initial,
  loading,
  checkedIn,
  checkedOut,
  failure,
}

/// ================= ATTENDANCE STATE =================
/// (Still SAME state hierarchy, no splitting)
class HrDashboardAttendanceState extends HrDashboardState {
  final AttendanceStatus status;
  final bool isCheckedIn;
  final Duration workingDuration;
  final String? message;
  final DateTime? checkInTime;

  const HrDashboardAttendanceState({
    this.status = AttendanceStatus.initial,
    this.isCheckedIn = false,
    this.workingDuration = Duration.zero,
    this.message,
    this.checkInTime,
  });

  HrDashboardAttendanceState copyWith({
    AttendanceStatus? status,
    bool? isCheckedIn,
    Duration? workingDuration,
    String? message,
    DateTime? checkInTime,
  }) {
    return HrDashboardAttendanceState(
      status: status ?? this.status,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      workingDuration: workingDuration ?? this.workingDuration,
      message: message ?? this.message,
      checkInTime: checkInTime ?? this.checkInTime,
    );
  }
}