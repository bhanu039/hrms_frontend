

import '../../leave_types/data/leave_type_modal.dart';

abstract class LeaveState {}

class LeaveInitialState extends LeaveState {}

// NEW STATES FOR LOADING DROPDOWN DATA
class LeaveTypesLoadingState extends LeaveState {}

class LeaveTypesLoadedState extends LeaveState {
  final List<LeaveTypeModel> leaveTypes;
  LeaveTypesLoadedState(this.leaveTypes);
}

class LeaveTypesErrorState extends LeaveState {
  final String error;
  LeaveTypesErrorState(this.error);
}

// REQUEST SUBMISSION STATES
class LeaveSubmittingState extends LeaveState {}
class LeaveSuccessState extends LeaveState {
  final String message;
  LeaveSuccessState(this.message);
}
class LeaveFailureState extends LeaveState {
  final String error;
  LeaveFailureState(this.error);
}
