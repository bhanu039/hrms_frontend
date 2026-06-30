class CompanyModel {

  final String id;
  final String name;
  final String email;

  final String ownerName;
  final String ownerEmail;

  final String legalName;

  final String phone;
  final String website;
  final String domain;

  final String companyLogo;

  final String industryTypeId;
  final String companySize;

  final int foundedYear;

  final double? latitude;
  final double? longitude;

  final String status;

  final bool isEmailVerified;
  final bool isProfileCompleted;

  final String? invitedAt;
  final String? activatedAt;
  final String? lastActiveAt;

  final String? inactiveAt;
  final String? deletedAt;

  final String? createdById;
  final String? createdAt;
  final String? updatedAt;

  final List<dynamic> documents;
  final List<dynamic> subscriptions;

  CompanyModel({

    required this.id,
    required this.name,
    required this.email,

    required this.ownerName,
    required this.ownerEmail,

    required this.legalName,

    required this.phone,
    required this.website,
    required this.domain,

    required this.companyLogo,

    required this.industryTypeId,
    required this.companySize,

    required this.foundedYear,

    this.latitude,
    this.longitude,

    required this.status,

    required this.isEmailVerified,
    required this.isProfileCompleted,

    this.invitedAt,
    this.activatedAt,
    this.lastActiveAt,

    this.inactiveAt,
    this.deletedAt,

    this.createdById,
    this.createdAt,
    this.updatedAt,

    required this.documents,
    required this.subscriptions,
  });

  /// ================= FROM JSON =================

  factory CompanyModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return CompanyModel(

      id: json["id"]?.toString() ?? "",

      name: json["name"]?.toString() ?? "",

      email: json["email"]?.toString() ?? "",

      ownerName: json["ownerName"]?.toString() ?? "",

      ownerEmail: json["ownerEmail"]?.toString() ?? "",

      legalName: json["legalName"]?.toString() ?? "",

      phone: json["phone"]?.toString() ?? "",

      website: json["website"]?.toString() ?? "",

      domain: json["domain"]?.toString() ?? "",

      companyLogo:
          json["companyLogo"]?.toString() ?? "",

      industryTypeId:
          json["industryTypeId"]?.toString() ?? "",

      companySize:
          json["companySize"]?.toString() ?? "",

      foundedYear:
          int.tryParse(
            json["foundedYear"]?.toString() ?? "0",
          ) ?? 0,

      latitude: json["latitude"] == null
          ? null
          : double.tryParse(
              json["latitude"].toString(),
            ),

      longitude: json["longitude"] == null
          ? null
          : double.tryParse(
              json["longitude"].toString(),
            ),

      status: json["status"]?.toString() ?? "",

      isEmailVerified:
          json["isEmailVerified"] ?? false,

      isProfileCompleted:
          json["isProfileCompleted"] ?? false,

      invitedAt:
          json["invitedAt"]?.toString(),

      activatedAt:
          json["activatedAt"]?.toString(),

      lastActiveAt:
          json["lastActiveAt"]?.toString(),

      inactiveAt:
          json["inactiveAt"]?.toString(),

      deletedAt:
          json["deletedAt"]?.toString(),

      createdById:
          json["createdById"]?.toString(),

      createdAt:
          json["createdAt"]?.toString(),

      updatedAt:
          json["updatedAt"]?.toString(),

      documents:
          json["documents"] is List
              ? json["documents"]
              : [],

      subscriptions:
          json["subscriptions"] is List
              ? json["subscriptions"]
              : [],
    );
  }

  /// ================= TO JSON =================

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "name": name,

      "email": email,

      "ownerName": ownerName,

      "ownerEmail": ownerEmail,

      "legalName": legalName,

      "phone": phone,

      "website": website,

      "domain": domain,

      "companyLogo": companyLogo,

      "industryTypeId": industryTypeId,

      "companySize": companySize,

      "foundedYear": foundedYear,

      "latitude": latitude,

      "longitude": longitude,

      "status": status,

      "isEmailVerified": isEmailVerified,

      "isProfileCompleted": isProfileCompleted,

      "invitedAt": invitedAt,

      "activatedAt": activatedAt,

      "lastActiveAt": lastActiveAt,

      "inactiveAt": inactiveAt,

      "deletedAt": deletedAt,

      "createdById": createdById,

      "createdAt": createdAt,

      "updatedAt": updatedAt,

      "documents": documents,

      "subscriptions": subscriptions,
    };
  }
}