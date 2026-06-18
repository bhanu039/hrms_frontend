

import '../data/company_dashbord_modal.dart';

abstract class CompanyDashboardState  {
  const CompanyDashboardState();

  @override
  List<Object?> get props => [];
}

class CompanyDashboardInitial extends CompanyDashboardState {}

class CompanyDashboardLoading extends CompanyDashboardState {}

class CompanyDashboardError extends CompanyDashboardState {
  final String message;

  const CompanyDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class CompanyDashboardLoaded extends CompanyDashboardState {
  final CompanyDashboardModel data;

  const CompanyDashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}