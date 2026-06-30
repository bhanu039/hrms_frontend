import '../data/emp_dashborad_modal.dart';

abstract class EmpDashboardState {}

class EmpDashboardInitial extends EmpDashboardState {}

class EmpDashboardLoading extends EmpDashboardState {}

class EmpDashboardLoaded extends EmpDashboardState {
  final bool? loading;
  final EmpDashboardModel dashboardData;
  final String? errorMessage;

  EmpDashboardLoaded(this.dashboardData, {this.errorMessage, this.loading = false});

  EmpDashboardLoaded copyWith({
    EmpDashboardModel? dashboardData,
    bool? loading,
    String? errorMessage,
  }) {
    return EmpDashboardLoaded(
      dashboardData ?? this.dashboardData,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
class ShowMessageState extends EmpDashboardState {
  final String message;

  ShowMessageState(this.message);
}


class EmpDashboardError extends EmpDashboardState {
  final String message;

  EmpDashboardError(this.message);
}