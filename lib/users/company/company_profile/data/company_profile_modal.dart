class CompanyProfileData {
  final String? id;
  final String? name;
  final String? email;
  final String? ownerName;
  final String? ownerEmail;
  final String? legalName;
  final String? phone;
  final String? website;
  final String? domain;
  final String? companyLogo;
  final String? industryTypeId;
  final String? companySize;
  final int? foundedYear;
  final double? latitude;
  final double? longitude;
  final int? geofenceRadius;
  final String? status;
  final bool? isEmailVerified;
  final bool? isProfileCompleted;
  final DateTime? invitedAt;
  final DateTime? activatedAt;
  final DateTime? lastActiveAt;
  final DateTime? inactiveAt;
  final DateTime? deletedAt;
  final String? createdById;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? cinNumber;
  final String? linkedinUrl;
  final String? signature;
  final String? termsAndConditions;
  final List<CompanyDocument>? documents;
  final IndustryType? industryType;
  final CurrentSubscription? currentSubscription;

  CompanyProfileData({
    this.id,
    this.name,
    this.email,
    this.ownerName,
    this.ownerEmail,
    this.legalName,
    this.phone,
    this.website,
    this.domain,
    this.companyLogo,
    this.industryTypeId,
    this.companySize,
    this.foundedYear,
    this.latitude,
    this.longitude,
    this.geofenceRadius,
    this.status,
    this.isEmailVerified,
    this.isProfileCompleted,
    this.invitedAt,
    this.activatedAt,
    this.lastActiveAt,
    this.inactiveAt,
    this.deletedAt,
    this.createdById,
    this.createdAt,
    this.updatedAt,
    this.cinNumber,
    this.linkedinUrl,
    this.signature,
    this.termsAndConditions,
    this.documents,
    this.industryType,
    this.currentSubscription,
  });

  factory CompanyProfileData.fromJson(Map<String, dynamic> json) {
    return CompanyProfileData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      ownerName: json['ownerName'] as String?,
      ownerEmail: json['ownerEmail'] as String?,
      legalName: json['legalName'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      domain: json['domain'] as String?,
      companyLogo: json['companyLogo'] as String?,
      industryTypeId: json['industryTypeId'] as String?,
      companySize: json['companySize'] as String?,
      foundedYear: json['foundedYear'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      geofenceRadius: json['geofenceRadius'] as int?,
      status: json['status'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      isProfileCompleted: json['isProfileCompleted'] as bool?,
      invitedAt: json['invitedAt'] != null ? DateTime.tryParse(json['invitedAt']) : null,
      activatedAt: json['activatedAt'] != null ? DateTime.tryParse(json['activatedAt']) : null,
      lastActiveAt: json['lastActiveAt'] != null ? DateTime.tryParse(json['lastActiveAt']) : null,
      inactiveAt: json['inactiveAt'] != null ? DateTime.tryParse(json['inactiveAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.tryParse(json['deletedAt']) : null,
      createdById: json['createdById'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      cinNumber: json['cinNumber'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      signature: json['signature'] as String?,
      termsAndConditions: json['termsAndConditions'] as String?,
      documents: json['documents'] != null
          ? (json['documents'] as List).map((i) => CompanyDocument.fromJson(i as Map<String, dynamic>)).toList()
          : null,
      industryType: json['industryType'] != null ? IndustryType.fromJson(json['industryType'] as Map<String, dynamic>) : null,
      currentSubscription: json['currentSubscription'] != null
          ? CurrentSubscription.fromJson(json['currentSubscription'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CompanyDocument {
  final String? id;
  final String? companyId;
  final String? name;
  final String? fileUrl;
  final String? status;
  final String? remarks;
  final DateTime? uploadedAt;
  final DateTime? verifiedAt;

  CompanyDocument({
    this.id,
    this.companyId,
    this.name,
    this.fileUrl,
    this.status,
    this.remarks,
    this.uploadedAt,
    this.verifiedAt,
  });

  factory CompanyDocument.fromJson(Map<String, dynamic> json) {
    return CompanyDocument(
      id: json['id'] as String?,
      companyId: json['companyId'] as String?,
      name: json['name'] as String?,
      fileUrl: json['fileUrl'] as String?,
      status: json['status'] as String?,
      remarks: json['remarks'] as String?,
      uploadedAt: json['uploadedAt'] != null ? DateTime.tryParse(json['uploadedAt']) : null,
      verifiedAt: json['verifiedAt'] != null ? DateTime.tryParse(json['verifiedAt']) : null,
    );
  }
}

class IndustryType {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IndustryType({this.id, this.name, this.createdAt, this.updatedAt});

  factory IndustryType.fromJson(Map<String, dynamic> json) {
    return IndustryType(
      id: json['id'] as String?,
      name: json['name'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class CurrentSubscription {
  final String? id;
  final String? companyId;
  final String? planId;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final PlanDetails? plan;
  final bool? isSubscriptionActive;

  CurrentSubscription({
    this.id,
    this.companyId,
    this.planId,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.plan,
    this.isSubscriptionActive,
  });

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) {
    return CurrentSubscription(
      id: json['id'] as String?,
      companyId: json['companyId'] as String?,
      planId: json['planId'] as String?,
      startDate: json['startDate'] != null ? DateTime.tryParse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      plan: json['plan'] != null ? PlanDetails.fromJson(json['plan'] as Map<String, dynamic>) : null,
      isSubscriptionActive: json['isSubscriptionActive'] as bool?,
    );
  }
}

class PlanDetails {
  final String? id;
  final String? name;
  final num? price;
  final int? duration;
  final Map<String, dynamic>? features;
  final DateTime? createdAt;

  PlanDetails({this.id, this.name, this.price, this.duration, this.features, this.createdAt});

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      id: json['id'] as String?,
      name: json['name'] as String?,
      price: json['price'] as num?,
      duration: json['duration'] as int?,
      features: json['features'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}
