abstract class AttendanceEvent {}

class AttendanceStarted extends AttendanceEvent {}

class AttendanceDateChanged extends AttendanceEvent {
  final String date;

  AttendanceDateChanged(this.date);
}

class AttendanceFromDateChanged extends AttendanceEvent {
  final String fromDate;

  AttendanceFromDateChanged(this.fromDate);
}

class AttendanceToDateChanged extends AttendanceEvent {
  final String toDate;

  AttendanceToDateChanged(this.toDate);
}

class AttendanceMonthChanged extends AttendanceEvent {
  final String month;

  AttendanceMonthChanged(this.month);
}

class AttendanceYearChanged extends AttendanceEvent {
  final String year;

  AttendanceYearChanged(this.year);
}

class AttendanceStatusChanged extends AttendanceEvent {
  final String status;

  AttendanceStatusChanged(this.status);
}

class AttendanceSortChanged extends AttendanceEvent {
  final String sort;

  AttendanceSortChanged(this.sort);
}

class ApplyFilters extends AttendanceEvent {}

class ResetFilters extends AttendanceEvent {}
