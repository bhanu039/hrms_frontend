import '../data/attendance_model.dart';

class AttendanceState {
  final bool isLoading;
  final String search;
  final String status;
  final String? fromDate;
  final String? toDate;
  final int currentPage;
  final AttendanceResponse? attendanceResponse;
  final String? eId;


  const AttendanceState({
    this.isLoading = false,
    this.search = '',
    this.status = '',
    this.fromDate,
    this.toDate,
    this.currentPage = 1,
    this.attendanceResponse,
    this.eId,
  });

  AttendanceState copyWith({
    bool? isLoading,

    String? search,
    String? status,
    String? fromDate,
    String? toDate,
    int? currentPage,
    AttendanceResponse? attendanceResponse,
    String? eid,  
    final AttendanceResponse? fullAttendence,


  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      search: search ?? this.search,
      status: status ?? this.status,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      currentPage: currentPage ?? this.currentPage,
      attendanceResponse: attendanceResponse ?? this.attendanceResponse,
      eId:eid??this.eId,
      
    );
  }
}
