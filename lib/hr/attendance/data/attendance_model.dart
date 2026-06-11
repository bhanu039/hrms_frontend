class AttendanceResponse {
  final String date;
  final AttendanceSummary summary;
  final Pagination pagination;
  final List<AttendanceRecord> records;

  AttendanceResponse({
    required this.date,
    required this.summary,
    required this.pagination,
    required this.records,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      date: json['date'] ?? '',
      summary: AttendanceSummary.fromJson(
        json['summary'] ?? {},
      ),
      pagination: Pagination.fromJson(
        json['pagination'] ?? {},
      ),
      records: (json['records'] as List<dynamic>? ?? [])
          .map((e) => AttendanceRecord.fromJson(e))
          .toList(),
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'summary': summary.toJson(),
      'pagination': pagination.toJson(),
      'records': records.map((e) => e.toJson()).toList(),
    };
  }
}

class AttendanceSummary {
  final int totalEmployees;
  final int present;
  final int absent;
  final int onLeave;

  AttendanceSummary({
    required this.totalEmployees,
    required this.present,
    required this.absent,
    required this.onLeave,
  });

  factory AttendanceSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceSummary(
      totalEmployees: json['totalEmployees'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      onLeave: json['onLeave'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEmployees': totalEmployees,
      'present': present,
      'absent': absent,
      'onLeave': onLeave,
    };
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalpages;
  final int totalrecords;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalpages,
    required this.totalrecords,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalpages: json['totalpages'] ?? 0,
      totalrecords: json['totalrecords'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalpages': totalpages,
      'totalrecords': totalrecords,
    };
  }
}

class AttendanceRecord {
  final String employeeId;
  final String firstName;
  final String lastName;
  final String status;
  final String? checkIn;
  final int? faceMatchScore;
  final String? checkInSelfie;
  final String? masterFacePhoto;
  final String? department;

  AttendanceRecord({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.checkIn,
    this.faceMatchScore,
    this.checkInSelfie,
    this.masterFacePhoto,
    this.department,
  });

  factory AttendanceRecord.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceRecord(
      employeeId: json['employeeId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      status: json['status'] ?? '',
      checkIn: json['checkIn'],
      faceMatchScore: json['faceMatchScore'],
      checkInSelfie: json['checkInSelfie'],
      masterFacePhoto: json['masterFacePhoto'],

      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'firstName': firstName,
      'lastName': lastName,
      'status': status,
      'checkIn': checkIn,
      'faceMatchScore': faceMatchScore,
      'checkInSelfie': checkInSelfie,
      'masterFacePhoto': masterFacePhoto,
      'department': department,
    };
  }

  String get fullName => '$firstName $lastName';
}