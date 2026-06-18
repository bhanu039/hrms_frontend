import '../data/emp_dashborad_modal.dart';

abstract class EmpDashboardState {}

class EmpDashboardInitial extends EmpDashboardState {}

class EmpDashboardLoading extends EmpDashboardState {}

class EmpDashboardLoaded extends EmpDashboardState {
  final EmpDashboardModel data;

  EmpDashboardLoaded(this.data);
}

class EmpDashboardError extends EmpDashboardState {
  final String message;

  EmpDashboardError(this.message);
}