import '../data/hr_dashbord_modal.dart';

/// ================= MAIN STATE =================
abstract class HrDashboardState {
  const HrDashboardState();
}

/// ================= DASHBOARD =================
class HrDashboardInitial extends HrDashboardState {}

class HrDashboardLoading extends HrDashboardState {}

class HrDashboardError extends HrDashboardState {
  final String message;

  const HrDashboardError(this.message);
}

class HrDashboardLoaded extends HrDashboardState {
  final bool? loading;
  final HrDashboardModel dashboardData;
  final String? errorMessage; // Keeps track of temporary errors like failed check-ins

  // Remove the closing brace here and pass clean defaults
  HrDashboardLoaded(
    this.dashboardData, {
    this.errorMessage,
    this.loading = false,
  }); // <--- FIX: Ended with a semicolon, class body remains open!

  // FIX: This method is now safely nested inside the class body parameters
  HrDashboardLoaded copyWith({
    HrDashboardModel? dashboardData,
    bool? loading,
    String? errorMessage, 
  }) {
    return HrDashboardLoaded(
      dashboardData ?? this.dashboardData,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage, 
    );
  }
} // <--- FIX: This single brace now closes the entire class body correctly
