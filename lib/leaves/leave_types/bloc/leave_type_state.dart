import '../data/leave_type_modal.dart';

enum LeaveTypeStatus { initial, loading, success, failure }

class LeaveTypeState {
  final LeaveTypeStatus status;
  final List<LeaveTypeModel> leaveTypes;
  final bool isActionLoading;
  final String? alertMessage;
  final bool isActionSuccess;

  LeaveTypeState({
    required this.status, 
    required this.leaveTypes, 
    required this.isActionLoading, 
    this.alertMessage, 
    required this.isActionSuccess
  });

  factory LeaveTypeState.initial() => LeaveTypeState(
        status: LeaveTypeStatus.initial, 
        leaveTypes: [], 
        isActionLoading: false, 
        alertMessage: null, 
        isActionSuccess: false
      );

  LeaveTypeState copyWith({
    LeaveTypeStatus? status, 
    List<LeaveTypeModel>? leaveTypes, 
    bool? isActionLoading, 
    String? alertMessage, 
    bool? isActionSuccess
  }) {
    return LeaveTypeState(
      status: status ?? this.status,
      leaveTypes: leaveTypes ?? this.leaveTypes,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      alertMessage: alertMessage,
      isActionSuccess: isActionSuccess ?? this.isActionSuccess,
    );
  }
}