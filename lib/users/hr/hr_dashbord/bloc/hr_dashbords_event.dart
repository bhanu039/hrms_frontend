import 'dart:io';

abstract class HrDashboardEvent {}

class LoadHrDashboard extends HrDashboardEvent {}

class CheckInRequested extends HrDashboardEvent {
  final File image;
  final double latitude;
  final double longitude;
  final String mode;
  

  CheckInRequested({
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.mode,
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
class SubmitWorkEvent extends HrDashboardEvent {
  final String workType;
  final String description;

  SubmitWorkEvent({
    required this.workType,
    required this.description,
  });
}

class AttendanceTimerTicked extends HrDashboardEvent {}
