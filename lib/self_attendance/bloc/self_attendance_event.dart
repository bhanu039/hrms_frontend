abstract class SelfAttendanceEvent {}

class AttendanceStarted extends SelfAttendanceEvent {}

class AttendanceDateChanged extends SelfAttendanceEvent {
  final String date;

  AttendanceDateChanged(this.date);
}

class AttendanceFromDateChanged extends SelfAttendanceEvent {
  final String fromDate;

  AttendanceFromDateChanged(this.fromDate);
}

class AttendanceToDateChanged extends SelfAttendanceEvent {
  final String toDate;

  AttendanceToDateChanged(this.toDate);
}

class AttendanceMonthChanged extends SelfAttendanceEvent {
  final String month;

  AttendanceMonthChanged(this.month);
}

class AttendanceYearChanged extends SelfAttendanceEvent {
  final String year;

  AttendanceYearChanged(this.year);
}

class AttendanceStatusChanged extends SelfAttendanceEvent {
  final String status;

  AttendanceStatusChanged(this.status);
}

class AttendanceSortChanged extends SelfAttendanceEvent {
  final String sort;

  AttendanceSortChanged(this.sort);
}

class ApplyFilters extends SelfAttendanceEvent {}

class ResetFilters extends SelfAttendanceEvent {}
