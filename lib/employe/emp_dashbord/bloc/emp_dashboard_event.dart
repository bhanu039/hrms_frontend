import 'dart:io';

abstract class EmpDashboardEvent {}

class EmpLoadDashboard extends EmpDashboardEvent {}

class CheckInEvent extends EmpDashboardEvent {
  final File? image;
  final double latitude;
  final double longitude;
final String? mode;

  CheckInEvent({
    required this.mode,
    required this.image,
    required this.latitude,
    required this.longitude,
  });
}

class CheckOutEvent extends EmpDashboardEvent {
  final File? image;
  final double latitude;
  final double longitude;

  CheckOutEvent({
    required this.image,
    required this.latitude,
    required this.longitude,
  });
}

class SubmitWorkEvent extends EmpDashboardEvent {
  final String workType;
  final String description;

  SubmitWorkEvent({
    required this.workType,
    required this.description,
  });
}
