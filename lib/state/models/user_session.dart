import 'package:flutter/foundation.dart';

class UserSession {
  const UserSession({
    required this.token,
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.createdAt,
    this.profileLogo,
    this.isProfileCompleted,
    this.companyid,
  });

  final String token;
  final String id;
  final String role;
  final String name;
  final String email;
  final String createdAt;
  final String? profileLogo;
  final bool? isProfileCompleted;
  final String? companyid;

  bool get isSuperAdmin => role == "SUPER_ADMIN";
  bool get isCompanyRole => role == "OWNER" || role == "COMPANY";

  bool get isHR => role == "HR";
  bool get isEmployee => role == "EMPLOYEE";
  print(String message) {
    // ignore: avoid_print
    print("[UserSession] $message");
  }

  UserSession copyWith({
    String? token,
    String? id,
    String? role,
    String? name,
    String? email,
    String? profileLogo,
    String? createdAt,
    bool? isProfileCompleted,
    String? companyid,
  }) {
    return UserSession(
      token: token ?? this.token,
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      profileLogo: profileLogo ?? this.profileLogo,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      companyid: companyid ?? this.companyid,
    );
  }

  factory UserSession.fromStorage({
    required String token,
    required String id,
    required String role,
    required String name,
    required String email,
    required String createdAt,
    String? profileLogo,
    bool? isProfileCompleted,
    String? companyid,
  }) {
    return UserSession(
      token: token,
      id: id,
      role: role,
      name: name,
      email: email,
      createdAt: createdAt,
      profileLogo: profileLogo,
      isProfileCompleted: isProfileCompleted,
      companyid: companyid,
    );
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
      id: user["id"]?.toString() ?? user["_id"]?.toString() ?? "",
      role: user["role"]?.toString() ?? "",
      name: user["name"]?.toString() ?? "",
      email: user["email"]?.toString() ?? "",
      createdAt: user["createdAt"]?.toString() ?? "",
      profileLogo: user["profileLogo"]?.toString(),
      isProfileCompleted: user["isProfileCompleted"] as bool?,
      companyid: user["companyId"]?.toString(),
    );
  }
}
UserSession? currentUserSession;
