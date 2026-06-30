abstract class LeaveTypeEvent {}
class FetchLeaveTypesEvent extends LeaveTypeEvent {}

class CreateLeaveTypeEvent extends LeaveTypeEvent {
  final String name;
  final int maxDays;
  CreateLeaveTypeEvent({required this.name, required this.maxDays});
}

class UpdateLeaveTypeEvent extends LeaveTypeEvent {
  final String id;
  final String name;
  final int maxDays;
  UpdateLeaveTypeEvent({required this.id, required this.name, required this.maxDays});
}

class DeleteLeaveTypeEvent extends LeaveTypeEvent {
  final String id;
  DeleteLeaveTypeEvent({required this.id});
}
