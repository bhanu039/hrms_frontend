abstract class AttendanceEvent {}

class AttendanceStarted extends AttendanceEvent {}

class AttendanceSearchChanged extends AttendanceEvent {
  final String query;

  AttendanceSearchChanged(this.query);
}

class AttendanceStatusChanged extends AttendanceEvent {
  final String? status;

  AttendanceStatusChanged(this.status);
}

class FromDateChanged extends AttendanceEvent {
  final String? fromDate;

  FromDateChanged(this.fromDate);
}

class ToDateChanged extends AttendanceEvent {
  final String? toDate;

  ToDateChanged(this.toDate);
}

class ApplyFilters extends AttendanceEvent {}

class LoadMoreEmployees extends AttendanceEvent {
    final int currentPage;

  LoadMoreEmployees(this.currentPage);

}

class ResetFilters extends AttendanceEvent {}

class FullAttendanceid extends AttendanceEvent {
  final String employeeId;

  FullAttendanceid(this.employeeId);
}
