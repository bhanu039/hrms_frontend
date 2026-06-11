abstract class AttendanceEvent {}

class AttendanceStarted extends AttendanceEvent {}

class AttendanceSearchChanged extends AttendanceEvent {
  final String query;

  AttendanceSearchChanged(this.query);
}

class AttendanceStatusChanged extends AttendanceEvent {
  final String status;

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
  LoadMoreEmployees({required this.currentPage});
}

class FullAttendanceid extends AttendanceEvent {
  final String? eId;
  FullAttendanceid({required this.eId});
}

class ResetFilters extends AttendanceEvent {}
