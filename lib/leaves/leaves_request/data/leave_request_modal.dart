class ApplyLeaveRequest {
  final String leaveTypeId;
  final String fromDate;
  final String toDate;
  final String reason;

  ApplyLeaveRequest({
    required this.leaveTypeId,
    required this.fromDate,
    required this.toDate,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'leaveTypeId': leaveTypeId,
      'fromDate': fromDate,
      'toDate': toDate,
      'reason': reason,
    };
  }
}
