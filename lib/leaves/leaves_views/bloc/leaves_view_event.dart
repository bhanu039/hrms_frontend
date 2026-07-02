sealed class LeaveViewEvent {}

class GetLeaves extends LeaveViewEvent {
    final String? datatype;
  
    GetLeaves([this.datatype]);
}

class RefreshLeaves extends LeaveViewEvent {
  final String? datatype;

  RefreshLeaves([this.datatype]);
}

class ApproveLeave extends LeaveViewEvent {
  final String datatype;
  final String leaveId;

  ApproveLeave(this.datatype, this.leaveId);
}

class RejectLeave extends LeaveViewEvent {
  final String datatype;
  final String leaveId;

  RejectLeave(this.leaveId, this.datatype);
}
class CancelLeave extends LeaveViewEvent {
  final String datatype;
  final String leaveId;

  CancelLeave(this.leaveId, this.datatype);
}
