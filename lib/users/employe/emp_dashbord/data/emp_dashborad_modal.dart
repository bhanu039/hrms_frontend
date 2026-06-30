class EmpDashboardModel {
  final Employee? employee;
  final SelfAttendance? selfAttendance;
  final MonthlyAttendance? monthlyAttendance;
  final List<LeaveBalance>? leaveBalance;
  final PendingActions? pendingActions;

  EmpDashboardModel({
    this.employee,
    this.selfAttendance,
    this.monthlyAttendance,
    this.leaveBalance,
    this.pendingActions,
  });

  factory EmpDashboardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return EmpDashboardModel();

    return EmpDashboardModel(
      employee: json['employee'] != null
          ? Employee.fromJson(json['employee'])
          : null,

      selfAttendance: json['selfAttendance'] != null
          ? SelfAttendance.fromJson(json['selfAttendance'])
          : null,

      monthlyAttendance: json['monthlyAttendance'] != null
          ? MonthlyAttendance.fromJson(json['monthlyAttendance'])
          : null,

      leaveBalance: json['leaveBalance'] != null
          ? (json['leaveBalance'] as List)
              .map((e) => LeaveBalance.fromJson(e))
              .toList()
          : [],

      pendingActions: json['pendingActions'] != null
          ? PendingActions.fromJson(json['pendingActions'])
          : null,
    );
  }
}
class Employee {
  final String? id;
  final String? name;
  final String? employeeCode;
  final String? department;
  final String? designation;
  final String? workModel;
  final String? profilePhoto;

  Employee({
    this.id,
    this.name,
    this.employeeCode,
    this.department,
    this.designation,
    this.workModel,
    this.profilePhoto,
  });

  factory Employee.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Employee();

    return Employee(
      id: json['id'],
      name: json['name'],
      employeeCode: json['employeeCode'],
      department: json['department'],
      designation: json['designation'],
      workModel: json['workModel'],
      profilePhoto: json['profilePhoto'],
    );
  }
}
class SelfAttendance {
  final bool? status;
  final String? checkInTime;
  final String? checkOutTime;
  final bool? isDailyWork;
  final String? workingHours;

  SelfAttendance({
    this.status,
    this.checkInTime,
    this.checkOutTime,
    this.isDailyWork,
    this.workingHours,
  });

  factory SelfAttendance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SelfAttendance();
    print("this is from the selfAttendance ${json['isDailyWork']}");

    return SelfAttendance(
      status: json['status']??false,
      checkInTime: json['checkInTime'],
      checkOutTime: json['checkOutTime'],
      isDailyWork: json['isDailyWork'],
      workingHours:json['workingHours']??'null',

    );
  
  }
  

}

class MonthlyAttendance {
  final String? month;
  final int? dayOfMonth;
  final int? present;
  final int? absent;
  final int? halfDays;
  final int? earlyExits;
  final int? attendanceRate;

  MonthlyAttendance({
    this.month,
    this.dayOfMonth,
    this.present,
    this.absent,
    this.halfDays,
    this.earlyExits,
    this.attendanceRate,
  });

  factory MonthlyAttendance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MonthlyAttendance();

    return MonthlyAttendance(
      month: json['month'],
      dayOfMonth: json['dayOfMonth'],
      present: json['present'],
      absent: json['absent'],
      halfDays: json['halfDays'],
      earlyExits: json['earlyExits'],
      attendanceRate: json['attendanceRate'],
    );
  }
}
class LeaveBalance {
  final String? type;
  final int? total;
  final int? used;
  final int? remaining;

  LeaveBalance({
    this.type,
    this.total,
    this.used,
    this.remaining,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LeaveBalance();

    return LeaveBalance(
      type: json['type'],
      total: json['total'],
      used: json['used'],
      remaining: json['remaining'],
    );
  }
}
class PendingActions {
  final int? total;
  final List<ActionItem>? items;

  PendingActions({
    this.total,
    this.items,
  });

  factory PendingActions.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PendingActions();

    return PendingActions(
      total: json['total'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => ActionItem.fromJson(e))
              .toList()
          : null,
    );
  }
}

class ActionItem {
  final String? type;
  final int? count;
  final String? label;

  ActionItem({
    this.type,
    this.count,
    this.label,
  });

  factory ActionItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ActionItem();

    return ActionItem(
      type: json['type'],
      count: json['count'],
      label: json['label'],
    );
  }
}