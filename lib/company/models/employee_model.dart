/// ================= EMPLOYEE MODEL =================

class EmployeeModel {
  final String id;
  final String employeeCode;
  final String firstName;
  final String middleName;
  final String lastName;
  final String profilePhoto;
  final String joiningDate;
  final String status;
  final String bgvStatus;

  final DesignationModel designation;

  EmployeeModel({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.profilePhoto,
    required this.joiningDate,
    required this.status,
    required this.bgvStatus,
    required this.designation,
  });

  factory EmployeeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmployeeModel(
      id: json["id"] ?? "",
      employeeCode:
          json["employeeCode"] ?? "",

      firstName:
          json["firstName"] ?? "",

      middleName:
          json["middleName"] ?? "",

      lastName:
          json["lastName"] ?? "",

      profilePhoto:
          json["profilePhoto"] ?? "",

      joiningDate:
          json["joiningDate"] ?? "",

      status:
          json["status"] ?? "",

      bgvStatus:
          json["bgvStatus"] ?? "",

      designation:
          DesignationModel.fromJson(
        json["designation"] ?? {},
      ),
    );
  }
}

/// ================= DESIGNATION MODEL =================

class DesignationModel {
  final String id;
  final String title;

  DesignationModel({
    required this.id,
    required this.title,
  });

  factory DesignationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DesignationModel(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
    );
  }
}