class CompanyDashboardModel {
  final Kpis? kpis;
  final Subscription? subscription;
  final TodaysAttendance? todaysAttendance;
  final Charts? charts;
  final PendingActions? pendingActions;
  final List<RecentActivity>? recentActivity;

  CompanyDashboardModel({
    this.kpis,
    this.subscription,
    this.todaysAttendance,
    this.charts,
    this.pendingActions,
    this.recentActivity,
  });

  factory CompanyDashboardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CompanyDashboardModel();

    return CompanyDashboardModel(
      kpis: json["kpis"] != null ? Kpis.fromJson(json["kpis"]) : null,
      subscription: json["subscription"] != null
          ? Subscription.fromJson(json["subscription"])
          : null,
      todaysAttendance: json["todaysAttendance"] != null
          ? TodaysAttendance.fromJson(json["todaysAttendance"])
          : null,
      charts: json["charts"] != null ? Charts.fromJson(json["charts"]) : null,
      pendingActions: json["pendingActions"] != null
          ? PendingActions.fromJson(json["pendingActions"])
          : null,
      recentActivity: (json["recentActivity"] as List?)
              ?.map((e) => RecentActivity.fromJson(e))
              .toList() ??
          [],
    );
  }
}

/// ================= KPIS =================
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
    if (json == null) return Kpis();

    return Kpis(
      totalEmployees:
          json["totalEmployees"] != null ? KpiItem.fromJson(json["totalEmployees"]) : null,
      attendanceRate:
          json["attendanceRate"] != null ? KpiItem.fromJson(json["attendanceRate"]) : null,
      onLeaveToday:
          json["onLeaveToday"] != null ? KpiItem.fromJson(json["onLeaveToday"]) : null,
      payrollDue:
          json["payrollDue"] != null ? KpiPayroll.fromJson(json["payrollDue"]) : null,
      totalProjects:
          json["totalProjects"] != null ? KpiItem.fromJson(json["totalProjects"]) : null,
    );
  }
}

class KpiItem {
  final int? value;
  final String? label;
  final String? trend;
  final String? trendDirection;

  KpiItem({
    this.value,
    this.label,
    this.trend,
    this.trendDirection,
  });

  factory KpiItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return KpiItem();

    return KpiItem(
      value: json["value"],
      label: json["label"],
      trend: json["trend"],
      trendDirection: json["trendDirection"],
    );
  }
}

class KpiPayroll {
  final int? value;
  final String? formatted;
  final int? dueInDays;

  KpiPayroll({
    this.value,
    this.formatted,
    this.dueInDays,
  });

  factory KpiPayroll.fromJson(Map<String, dynamic>? json) {
    if (json == null) return KpiPayroll();

    return KpiPayroll(
      value: json["value"],
      formatted: json["formatted"],
      dueInDays: json["dueInDays"],
    );
  }
}

/// ================= SUBSCRIPTION =================
class Subscription {
  final String? planName;
  final String? status;
  final DateTime? validUntil;
  final int? daysRemaining;
  final int? usagePercentage;

  Subscription({
    this.planName,
    this.status,
    this.validUntil,
    this.daysRemaining,
    this.usagePercentage,
  });

  factory Subscription.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Subscription();

    return Subscription(
      planName: json["planName"],
      status: json["status"],
      validUntil: DateTime.tryParse(json["validUntil"] ?? ""),
      daysRemaining: json["daysRemaining"],
      usagePercentage: json["usagePercentage"],
    );
  }
}

/// ================= ATTENDANCE =================
class TodaysAttendance {
  final String? date;
  final int? totalExpected;
  final AttendanceBreakdown? breakdown;

  TodaysAttendance({
    this.date,
    this.totalExpected,
    this.breakdown,
  });

  factory TodaysAttendance.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TodaysAttendance();

    return TodaysAttendance(
      date: json["date"],
      totalExpected: json["totalExpected"],
      breakdown: json["breakdown"] != null
          ? AttendanceBreakdown.fromJson(json["breakdown"])
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
    if (json == null) return AttendanceBreakdown();

    return AttendanceBreakdown(
      present: json["present"],
      absent: json["absent"],
      onLeave: json["onLeave"],
      earlyExit: json["earlyExit"],
    );
  }
}

/// ================= CHARTS =================
class Charts {
  final List<DepartmentHeadcount>? departmentHeadcount;
  final WorkModelSplit? workModelSplit;

  Charts({
    this.departmentHeadcount,
    this.workModelSplit,
  });

  factory Charts.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Charts();

    return Charts(
      departmentHeadcount: (json["departmentHeadcount"] as List?)
              ?.map((e) => DepartmentHeadcount.fromJson(e))
              .toList() ??
          [],
      workModelSplit: json["workModelSplit"] != null
          ? WorkModelSplit.fromJson(json["workModelSplit"])
          : null,
    );
  }
}

class DepartmentHeadcount {
  final String? department;
  final int? count;

  DepartmentHeadcount({
    this.department,
    this.count,
  });

  factory DepartmentHeadcount.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DepartmentHeadcount();

    return DepartmentHeadcount(
      department: json["department"],
      count: json["count"],
    );
  }
}

class WorkModelSplit {
  final int? wfo;
  final int? wfh;
  final int? hybrid;

  WorkModelSplit({
    this.wfo,
    this.wfh,
    this.hybrid,
  });

  factory WorkModelSplit.fromJson(Map<String, dynamic>? json) {
    if (json == null) return WorkModelSplit();

    return WorkModelSplit(
      wfo: json["WFO"],
      wfh: json["WFH"],
      hybrid: json["HYBRID"],
    );
  }
}

/// ================= PENDING ACTIONS =================
class PendingActions {
  final int? total;
  final List<PendingItem>? items;

  PendingActions({
    this.total,
    this.items,
  });

  factory PendingActions.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PendingActions();

    return PendingActions(
      total: json["total"],
      items: (json["items"] as List?)
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

  PendingItem({
    this.type,
    this.count,
    this.label,
  });

  factory PendingItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PendingItem();

    return PendingItem(
      type: json["type"],
      count: json["count"],
      label: json["label"],
    );
  }
}

/// ================= RECENT ACTIVITY =================
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
    if (json == null) return RecentActivity();

    return RecentActivity(
      id: json["id"],
      type: json["type"],
      title: json["title"],
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      iconType: json["iconType"],
    );
  }
}