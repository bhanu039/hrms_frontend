import '../data/leave_request_modal.dart';

abstract class LeaveEvent {}
class FetchLeaveTypesEvent extends LeaveEvent {}

class SubmitLeaveRequestEvent extends LeaveEvent {
  final ApplyLeaveRequest request;

  SubmitLeaveRequestEvent(this.request);
}
