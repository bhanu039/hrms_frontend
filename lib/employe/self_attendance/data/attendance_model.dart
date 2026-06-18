class SelfAttendanceResponse {
  final SelfAttendanceSummary summary;
  final List<SelfAttendanceRecord> history;

  SelfAttendanceResponse({required this.summary, required this.history});

  factory SelfAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return SelfAttendanceResponse(
      summary: SelfAttendanceSummary.fromJson(json['summary'] ?? {}),
      history: (json['history'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                SelfAttendanceRecord.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'history': history.map((item) => item.toJson()).toList(),
    };
  }
}

class SelfAttendanceSummary {
  final String startDate;
  final String endDate;
  final int totalDays;
  final int totalWorkingDays;
  final int present;
  final int absent;
  final int halfDays;
  final int earlyExits;
  final int leaves;
  final int weekOffs;
  final int late;

  SelfAttendanceSummary({
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.totalWorkingDays,
    required this.present,
    required this.absent,
    required this.halfDays,
    required this.earlyExits,
    required this.leaves,
    required this.weekOffs,
    required this.late,
  });

  factory SelfAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return SelfAttendanceSummary(
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      totalDays: json['totalDays'] ?? 0,
      totalWorkingDays: json['totalWorkingDays'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      halfDays: json['halfDays'] ?? 0,
      earlyExits: json['earlyExits'] ?? 0,
      leaves: json['leaves'] ?? 0,
      weekOffs: json['weekOffs'] ?? 0,
      late: json['late'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'totalDays': totalDays,
      'totalWorkingDays': totalWorkingDays,
      'present': present,
      'absent': absent,
      'halfDays': halfDays,
      'earlyExits': earlyExits,
      'leaves': leaves,
      'weekOffs': weekOffs,
      'late': late,
    };
  }
}

class SelfAttendanceRecord {
  final String date;
  final String dayOfWeek;
  final String status;
  final String? workTypeForToday;
  final String? checkIn;
  final String? checkOut;
  final String workingHours;
  final bool isLate;
  final bool isEarlyCheckout;
  final bool isAutoCheckout;
  final String? checkoutReason;
  final String? dailyWorkTitle;
  final String? dailyWorkSummary;
  final String? workSubmittedAt;

  SelfAttendanceRecord({
    required this.date,
    required this.dayOfWeek,
    required this.status,
    this.workTypeForToday,
    this.checkIn,
    this.checkOut,
    required this.workingHours,
    required this.isLate,
    required this.isEarlyCheckout,
    required this.isAutoCheckout,
    this.checkoutReason,
    this.dailyWorkTitle,
    this.dailyWorkSummary,
    this.workSubmittedAt,
  });

  factory SelfAttendanceRecord.fromJson(Map<String, dynamic> json) {
    return SelfAttendanceRecord(
      date: json['date'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      status: json['status'] ?? '',
      workTypeForToday: json['workTypeForToday'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      workingHours: json['workingHours'] ?? '0h 0m',
      isLate: json['isLate'] ?? false,
      isEarlyCheckout: json['isEarlyCheckout'] ?? false,
      isAutoCheckout: json['isAutoCheckout'] ?? false,
      checkoutReason: json['checkoutReason'],
      dailyWorkTitle: json['dailyWorkTitle'],
      dailyWorkSummary: json['dailyWorkSummary'],
      workSubmittedAt: json['workSubmittedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dayOfWeek': dayOfWeek,
      'status': status,
      'workTypeForToday': workTypeForToday,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'workingHours': workingHours,
      'isLate': isLate,
      'isEarlyCheckout': isEarlyCheckout,
      'isAutoCheckout': isAutoCheckout,
      'checkoutReason': checkoutReason,
      'dailyWorkTitle': dailyWorkTitle,
      'dailyWorkSummary': dailyWorkSummary,
      'workSubmittedAt': workSubmittedAt,
    };
  }
}
