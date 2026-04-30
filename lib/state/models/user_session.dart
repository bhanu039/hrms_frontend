class UserSession {
  const UserSession({
    required this.token,
    required this.id,
    required this.role,
    required this.name,
    required this.email,
  });

  final String token;
  final String id;
  final String role;
  final String name;
  final String email;

  bool get isSuperAdmin => role == "SUPER_ADMIN";
  bool get isCompanyLikeRole => role == "COMPANY" || role == "EMPLOYEE";

  UserSession copyWith({
    String? token,
    String? id,
    String? role,
    String? name,
    String? email,
  }) {
    return UserSession(
      token: token ?? this.token,
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory UserSession.fromStorage({
    required String token,
    required String id,
    required String role,
    required String name,
    required String email,
  }) {
    return UserSession(
      token: token,
      id: id,
      role: role,
      name: name,
      email: email,
    );
  }

  factory UserSession.fromLoginResponse(Map<String, dynamic> data) {
    final user = Map<String, dynamic>.from(data["user"] as Map);
    return UserSession(
      token: data["token"]?.toString() ?? "",
      id: user["id"]?.toString() ?? user["_id"]?.toString() ?? "",
      role: user["role"]?.toString() ?? "",
      name: user["name"]?.toString() ?? "",
      email: user["email"]?.toString() ?? "",
    );
  }
}

