

abstract class CompanyDashboardEvent  {
  const CompanyDashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Load dashboard with filters
class LoadDashboard extends CompanyDashboardEvent {
  

  const LoadDashboard();

  @override
  List<Object?> get props => [];
}

/// Refresh dashboard
class RefreshDashboard extends CompanyDashboardEvent {
 

  const RefreshDashboard();
}