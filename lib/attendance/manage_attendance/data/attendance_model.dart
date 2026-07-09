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
    final payload = json['data'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    return AttendanceResponse(
      date: payload['date'] ?? '',
      summary: AttendanceSummary.fromJson(payload['summary'] ?? {}),
      pagination: Pagination.fromJson(payload['pagination'] ?? {}),
      records: (payload['records'] as List<dynamic>? ?? [])
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
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

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
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
      currentPage: json['currentPage'] ?? json['page'] ?? 1,
      totalPages: json['totalPages'] ?? json['total_pages'] ?? 1,
      totalpages: json['totalpages'] ?? json['totalPages'] ?? 0,
      totalrecords: json['totalrecords'] ?? json['totalRecords'] ?? 0,
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
  final String? checkOut;
  final String? date;
  final String? workingHours;
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
    this.checkOut,
    this.date,
    this.workingHours,
    this.faceMatchScore,
    this.checkInSelfie,
    this.masterFacePhoto,
    this.department,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final fullName =
        (json['fullName'] ?? json['employeeName'] ?? json['name'] ?? '')
            .toString()
            .trim();
    final nameParts = fullName.split(RegExp(r'\s+'));

    return AttendanceRecord(
      employeeId: json['employeeId'] ?? json['employee_id'] ?? json['id'] ?? '',
      firstName:
          json['firstName'] ??
          json['employeeFirstName'] ??
          (nameParts.isNotEmpty ? nameParts.first : ''),
      lastName:
          json['lastName'] ??
          json['employeeLastName'] ??
          (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : ''),
      status: json['status'] ?? json['attendanceStatus'] ?? '',
      checkIn: json['checkIn'] ?? json['check_in'] ?? json['checkInTime'],
      checkOut: json['checkOut'] ?? json['check_out'] ?? json['checkOutTime'],
      date: json['date'] ?? json['attendanceDate'] ?? json['attendance_date'],
      workingHours: json['workingHours'] ?? json['working_hours'] ?? json['workHours'],
      faceMatchScore: json['faceMatchScore'] ?? json['face_match_score'],
      checkInSelfie:
          json['checkInSelfie'] ?? json['check_in_selfie'] ?? json['selfie'],
      masterFacePhoto: json['masterFacePhoto'] ?? json['master_face_photo'],
      department: json['department'] ?? json['dept'] ?? json['departmentName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'firstName': firstName,
      'lastName': lastName,
      'status': status,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'date': date,
      'workingHours': workingHours,
      'faceMatchScore': faceMatchScore,
      'checkInSelfie': checkInSelfie,
      'masterFacePhoto': masterFacePhoto,
      'department': department,
    };
  }

  String get fullName => '$firstName $lastName';
}
