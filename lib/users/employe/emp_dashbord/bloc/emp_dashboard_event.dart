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
   final String? titile;
 final  String? description;
 final bool? isDailyWork;
 final String? reason;

  CheckOutEvent({
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.titile,
    required this.description,
    required this.isDailyWork,
    required this.reason,
  });
}



