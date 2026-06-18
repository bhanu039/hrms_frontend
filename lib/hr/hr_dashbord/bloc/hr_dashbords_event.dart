import 'dart:io';

abstract class HrDashboardEvent {}

class LoadHrDashboard extends HrDashboardEvent {}

class CheckInRequested extends HrDashboardEvent {
  final File image;
  final double latitude;
  final double longitude;

  CheckInRequested({
    required this.image,
    required this.latitude,
    required this.longitude,
  });
}

class CheckOutRequested extends HrDashboardEvent {
  final File image;
  final double latitude;
  final double longitude;

  CheckOutRequested({
    required this.image,
    required this.latitude,
    required this.longitude,
  });
}

class AttendanceTimerTicked extends HrDashboardEvent {}