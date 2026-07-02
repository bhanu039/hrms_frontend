


import 'package:goexperts/leaves/leaves_views/data/leaves_view_modal.dart';

enum LeaveStatus {
  initial,
  loading,
  success,
  failure,
}

class LeavesViewState  {
  final LeaveStatus status;
  final List<LeaveViewModel> leaves;
  final String? errorMessage;
  final String? successMessage;
  final String? actionLoadingId;

  const LeavesViewState({
    this.status = LeaveStatus.initial,
    this.leaves = const [],
    this.errorMessage,
    this.successMessage,
    this.actionLoadingId,
  });

  LeavesViewState copyWith({
    LeaveStatus? status,
    List<LeaveViewModel>? leaves,
    String? errorMessage,
    String? successMessage,
    String? actionLoadingId,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearActionLoading = false,
  }) {
    return LeavesViewState(
      status: status ?? this.status,
      leaves: leaves ?? this.leaves,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      actionLoadingId: clearActionLoading
          ? null
          : (actionLoadingId ?? this.actionLoadingId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        leaves,
        errorMessage,
        successMessage,
        actionLoadingId,
      ];
}