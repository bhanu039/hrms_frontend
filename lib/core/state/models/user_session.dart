import 'package:flutter/foundation.dart';

class UserSession {
  const UserSession({
    required this.token,
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.isFullRegistered,
    this.companyid,
  });

  final String token;
  final String id;
  final String role;
  final String name;
  final String email;
  final String createdAt;
  final bool? isFullRegistered;
  final String? companyid;

  bool get isSuperAdmin => role == "SUPER_ADMIN";
  bool get isCompanyRole => role == "OWNER" || role == "COMPANY";

  bool get isHR => role == "HR";
  bool get isEmployee => role == "EMPLOYEE";
  print(String message) {
    // ignore: avoid_print
    print("[UserSession] $message");
  }

 


  factory UserSession.fromLoginResponse(Map<String, dynamic> data) {
    final user = (data["user"] is Map)
        ? Map<String, dynamic>.from(data["user"])
        : <String, dynamic>{};
    debugPrint(
      'Creating UserSession from login response: '
      'token=${data["token"]}, user=$user',
    );
    return UserSession(
      token: data["token"]?.toString() ?? "",
      id:  user["id"]?.toString() ?? "",
      role: user["role"]?.toString() ?? "",
      name: user["name"]?.toString() ?? "",
      email: user["email"]?.toString() ?? "",
      createdAt: user["createdAt"]?.toString() ?? "",
      isFullRegistered:user["isFullRegistered"]??false,
      companyid: user["companyId"]?.toString()??"",
    );
  }
}
UserSession? currentUserSession;

