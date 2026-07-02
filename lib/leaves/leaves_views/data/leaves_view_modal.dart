import 'package:goexperts/core/state/models/Employee_data_Model.dart';

class LeaveViewModel {
  final String id;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  final String status;
  final Employee? employee;
  final LeaveType leaveType;
  final User? user;

  LeaveViewModel({
    required this.id,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
    this.employee,
    required this.leaveType,
    this.user,
  });

  factory LeaveViewModel.fromJson(Map<String, dynamic> json) {
    return LeaveViewModel(
      id: json["id"] ?? "",
      fromDate: DateTime.parse(json["fromDate"]),
      toDate: DateTime.parse(json["toDate"]),
      reason: json["reason"] ?? "",
      status: json["status"] ?? "",
      employee: Employee.fromJson(json["employee"] ?? {}),
      leaveType: LeaveType.fromJson(json["leaveType"] ?? {}),
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fromDate": fromDate.toIso8601String(),
      "toDate": toDate.toIso8601String(),
      "reason": reason,
      "status": status,
      "employee": employee?.toJson(),
      "leaveType": leaveType.toJson(),
      "user": user?.toJson(),
    };
  }

  LeaveViewModel copyWith({
    String? id,
    DateTime? fromDate,
    DateTime? toDate,
    String? reason,
    String? status,
    Employee? employee,
    LeaveType? leaveType,
    User? user,
  }) {
    return LeaveViewModel(
      id: id ?? this.id,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      employee: employee ?? this.employee,
      leaveType: leaveType ?? this.leaveType,
      user: user ?? this.user,
    );
  }
}

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;


  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["id"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      profileImageUrl: json["profilePhoto"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "profileImageUrl": profileImageUrl,
    };
  }

  String get fullName => "$firstName $lastName";
}

class LeaveType {
  final String name;

  LeaveType({required this.name});

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(name: json["name"] ?? "");
  }
   Map<String, dynamic> toJson() {
    return {"name": name};
  }
}

class User {
  final String mail;

  User({required this.mail});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(mail: json["mail"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {"mail": mail};
  }
}
