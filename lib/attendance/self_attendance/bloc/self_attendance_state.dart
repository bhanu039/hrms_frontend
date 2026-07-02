import '../data/attendance_model.dart';

class SelfAttendanceState {
  final bool isLoading;
  final String date;
  final String fromDate;
  final String toDate;
  final String month;
  final String year;
  final String status;
  final String sort;
  final SelfAttendanceResponse? attendanceResponse;
  final String errorMessage;

  const SelfAttendanceState({
    this.isLoading = false,
    this.date = '',
    this.fromDate = '',
    this.toDate = '',
    this.month = '',
    this.year = '',
    this.status = '',
    this.sort = 'desc',
    this.attendanceResponse,
    this.errorMessage = '',
  });

  SelfAttendanceState copyWith({
    bool? isLoading,
    String? date,
    String? fromDate,
    String? toDate,
    String? month,
    String? year,
    String? status,
    String? sort,
    SelfAttendanceResponse? attendanceResponse,
    String? errorMessage,
  }) {
    return SelfAttendanceState(
      isLoading: isLoading ?? this.isLoading,
      date: date ?? this.date,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      month: month ?? this.month,
      year: year ?? this.year,
      status: status ?? this.status,
      sort: sort ?? this.sort,
      attendanceResponse: attendanceResponse ?? this.attendanceResponse,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
