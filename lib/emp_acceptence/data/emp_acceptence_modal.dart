class EmployeeReviewModel {
  final String id;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final String status;
  final String bgvStatus;
  final String joiningDate;
  final String employmentType;
  final String workModel;
  final String? profilePhoto;
  final Map<String, dynamic> department;
  final Map<String, dynamic> designation;
  final List<dynamic> education;
  final List<dynamic> experience;
  final Map<String, dynamic> skills;
  final Map<String, dynamic> bankDetails;
  final Map<String, dynamic> nominee;
  final Map<String, dynamic> compliance;
  final List<ReviewDocument> documents;

  EmployeeReviewModel({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.bgvStatus,
    required this.joiningDate,
    required this.employmentType,
    required this.workModel,
    this.profilePhoto,
    required this.department,
    required this.designation,
    required this.education,
    required this.experience,
    required this.skills,
    required this.bankDetails,
    required this.nominee,
    required this.compliance,
    required this.documents,
  });

  factory EmployeeReviewModel.fromJson(Map<String, dynamic> json) {
    return EmployeeReviewModel(
      id: json['id'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      status: json['status'] ?? 'PENDING',
      bgvStatus: json['bgvStatus'] ?? 'PENDING',
      joiningDate: json['joiningDate'] ?? '',
      employmentType: json['employmentType'] ?? 'N/A',
      workModel: json['workModel'] ?? 'N/A',
      profilePhoto: json['profilePhoto'],
      department: json['department'] is Map<String, dynamic> ? json['department'] : {'name': json['department'] ?? 'N/A'},
      designation: json['designation'] is Map<String, dynamic> ? json['designation'] : {'title': json['designation'] ?? 'N/A'},
      education: json['education'] ?? [],
      experience: json['experience'] ?? [],
      skills: json['skills'] ?? {},
      bankDetails: json['bankDetails'] ?? {},
      nominee: json['nominee'] ?? {},
      compliance: json['compliance'] ?? {},
      documents: (json['documents'] as List? ?? [])
          .map((d) => ReviewDocument.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ReviewDocument {
  final String id;
  final String name;
  final String fileUrl;
  final String status;

  ReviewDocument({required this.id, required this.name, required this.fileUrl, required this.status});

  factory ReviewDocument.fromJson(Map<String, dynamic> json) {
    return ReviewDocument(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Document',
      fileUrl: json['fileUrl'] ?? '',
      status: json['status'] ?? 'PENDING',
    );
  }
}
