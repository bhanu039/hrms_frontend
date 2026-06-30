class HrDashboardModel {
  final Kpis? kpis;
  final TodaysAttendance? todaysAttendance;
  final SelfAttendance? selfAttendance;
  final Charts? charts;
  final PendingActions? pendingActions;
  final List<RecentActivity>? recentActivity;

  HrDashboardModel({
    this.kpis,
    this.todaysAttendance,
    this.selfAttendance,
    this.charts,
    this.pendingActions,
    this.recentActivity,
  });

  factory HrDashboardModel.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};

    return HrDashboardModel(
      kpis: data["kpis"] != null ? Kpis.fromJson(data["kpis"]) : null,
      selfAttendance: data["selfAttendance"] != null
          ? SelfAttendance.fromJson(data["selfAttendance"])
          : null,

      todaysAttendance: data["todaysAttendance"] != null
          ? TodaysAttendance.fromJson(data["todaysAttendance"])
          : null,
      charts: data["charts"] != null ? Charts.fromJson(data["charts"]) : null,
      pendingActions: data["pendingActions"] != null
          ? PendingActions.fromJson(data["pendingActions"])
          : null,
      recentActivity:
          (data["recentActivity"] as List?)
              ?.map((e) => RecentActivity.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Kpis {
  final KpiItem? totalEmployees;
  final KpiItem? attendanceRate;
  final KpiItem? onLeaveToday;
  final KpiPayroll? payrollDue;
  final KpiItem? totalProjects;

  Kpis({
    this.totalEmployees,
    this.attendanceRate,
    this.onLeaveToday,
    this.payrollDue,
    this.totalProjects,
  });

  factory Kpis.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};

    return Kpis(
      totalEmployees: data["totalEmployees"] != null
          ? KpiItem.fromJson(data["totalEmployees"])
          : null,
      attendanceRate: data["attendanceRate"] != null
          ? KpiItem.fromJson(data["attendanceRate"])
          : null,
      onLeaveToday: data["onLeaveToday"] != null
          ? KpiItem.fromJson(data["onLeaveToday"])
          : null,
      payrollDue: data["payrollDue"] != null
          ? KpiPayroll.fromJson(data["payrollDue"])
          : null,
      totalProjects: data["totalProjects"] != null
          ? KpiItem.fromJson(data["totalProjects"])
          : null,
    );
  }
}

class KpiItem {
  final int? value;
  final String? label;
  final String? trend;
  final String? trendDirection;

  KpiItem({this.value, this.label, this.trend, this.trendDirection});

  factory KpiItem.fromJson(Map<String, dynamic>? json) {
    return KpiItem(
      value: json?["value"],
      label: json?["label"],
      trend: json?["trend"],
      trendDirection: json?["trendDirection"],
    );
  }
}

class KpiPayroll {
  final int? value;
  final String? formatted;
  final int? dueInDays;

  KpiPayroll({this.value, this.formatted, this.dueInDays});

  factory KpiPayroll.fromJson(Map<String, dynamic>? json) {
    return KpiPayroll(
      value: json?["value"],
      formatted: json?["formatted"],
      dueInDays: json?["dueInDays"],
    );
  }
}

/* ---------------- SELF ATTENDANCE ---------------- */
class SelfAttendance {
  final bool status;
  final String? checkInTime;
  final String? checkOutTime;
  final String? workingHours;

  SelfAttendance({required this.status, this.checkInTime, this.checkOutTime,this.workingHours});

  factory SelfAttendance.fromJson(Map<String, dynamic> json) {
    return SelfAttendance(
      status: json['status'] ?? false,
      checkInTime: json['checkInTime'] ?? "--",
      checkOutTime: json['checkOutTime'],
      workingHours: json['workingHours'] ?? 'null',
    );
  }
}

class TodaysAttendance {
  final String? date;
  final int? totalExpected;
  final AttendanceBreakdown? breakdown;

  TodaysAttendance({this.date, this.totalExpected, this.breakdown});

  factory TodaysAttendance.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};

    return TodaysAttendance(
      date: data["date"],
      totalExpected: data["totalExpected"],
      breakdown: data["breakdown"] != null
          ? AttendanceBreakdown.fromJson(data["breakdown"])
          : null,
    );
  }
}

class AttendanceBreakdown {
  final int? present;
  final int? absent;
  final int? onLeave;
  final int? earlyExit;

  AttendanceBreakdown({
    this.present,
    this.absent,
    this.onLeave,
    this.earlyExit,
  });

  factory AttendanceBreakdown.fromJson(Map<String, dynamic>? json) {
    return AttendanceBreakdown(
      present: json?["present"],
      absent: json?["absent"],
      onLeave: json?["onLeave"],
      earlyExit: json?["earlyExit"],
    );
  }
}

class Charts {
  final List<DepartmentHeadcount>? departmentHeadcount;
  final WorkModelSplit? workModelSplit;

  Charts({this.departmentHeadcount, this.workModelSplit});

  factory Charts.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};

    return Charts(
      departmentHeadcount:
          (data["departmentHeadcount"] as List?)
              ?.map((e) => DepartmentHeadcount.fromJson(e))
              .toList() ??
          [],
      workModelSplit: data["workModelSplit"] != null
          ? WorkModelSplit.fromJson(data["workModelSplit"])
          : null,
    );
  }
}

class DepartmentHeadcount {
  final String? department;
  final int? count;

  DepartmentHeadcount({this.department, this.count});

  factory DepartmentHeadcount.fromJson(Map<String, dynamic>? json) {
    return DepartmentHeadcount(
      department: json?["department"],
      count: json?["count"],
    );
  }
}

class WorkModelSplit {
  final int? wfo;
  final int? wfh;
  final int? hybrid;

  WorkModelSplit({this.wfo, this.wfh, this.hybrid});

  factory WorkModelSplit.fromJson(Map<String, dynamic>? json) {
    return WorkModelSplit(
      wfo: json?["WFO"],
      wfh: json?["WFH"],
      hybrid: json?["HYBRID"],
    );
  }
}

class PendingActions {
  final int? total;
  final List<PendingItem>? items;

  PendingActions({this.total, this.items});

  factory PendingActions.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};

    return PendingActions(
      total: data["total"],
      items:
          (data["items"] as List?)
              ?.map((e) => PendingItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PendingItem {
  final String? type;
  final int? count;
  final String? label;

  PendingItem({this.type, this.count, this.label});

  factory PendingItem.fromJson(Map<String, dynamic>? json) {
    return PendingItem(
      type: json?["type"],
      count: json?["count"],
      label: json?["label"],
    );
  }
}

class RecentActivity {
  final String? id;
  final String? type;
  final String? title;
  final DateTime? timestamp;
  final String? iconType;

  RecentActivity({
    this.id,
    this.type,
    this.title,
    this.timestamp,
    this.iconType,
  });

  factory RecentActivity.fromJson(Map<String, dynamic>? json) {
    return RecentActivity(
      id: json?["id"],
      type: json?["type"],
      title: json?["title"],
      timestamp: DateTime.tryParse(json?["timestamp"] ?? ""),
      iconType: json?["iconType"],
    );
  }
}
