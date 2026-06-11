// model/profile_model.dart

import 'dart:io';

class FullRegModel {
  // ================= BASIC =================
  final String name;
  final String legalName;
  final String domain;
  final String website;
  final String phone;

  // ================= COMPANY =================
  final String companySize;
  final String foundedYear;
  final String workModel;
  final String shiftType;

  // ================= PAYROLL =================
  final String currency;
  final String salaryCycle;
  final bool pfEnabled;
  final String pfPercentage;

  // ================= LOCATION =================
  final String timezone;
  final String dateFormat;
  final String language;
  final String address1;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final double? latitude;
  final double? longitude;

  // ================= TAX =================
  final String gstNumber;
  final String panNumber;
  final String tanNumber;
  final String cinNumber;
  final bool declared;
  final File? companyLogo;
  final File? signature;

  FullRegModel({
    this.name = "",
    this.legalName = "",
    this.domain = "",
    this.website = "",
    this.phone = "",
    this.companySize = "",
    this.foundedYear = "",
    this.workModel = "",
    this.shiftType = "",
    this.currency = "",
    this.salaryCycle = "",
    this.pfEnabled = false,
    this.pfPercentage = "",
    this.timezone = "",
    this.dateFormat = "",
    this.language = "",
    this.address1 = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.pincode = "",
    this.latitude,
    this.longitude,
    this.gstNumber = "",
    this.panNumber = "",
    this.tanNumber = "",
    this.cinNumber = "",
    this.declared = false,
    this.companyLogo,
    this.signature,
  });

  FullRegModel copyWith({
    String? name,
    String? legalName,
    String? domain,
    String? website,
    String? phone,
    String? companySize,
    String? foundedYear,
    String? workModel,
    String? shiftType,
    String? currency,
    String? salaryCycle,
    bool? pfEnabled,
    String? pfPercentage,
    String? timezone,
    String? dateFormat,
    String? language,
    String? address1,
    String? city,
    String? state,
    String? country,
    String? pincode,
    double? latitude,
    double? longitude,
    String? gstNumber,
    String? panNumber,
    String? tanNumber,
    String? cinNumber,
    bool? declared,
    File? companyLogo,
    File? signature,
    
  }) {
    return FullRegModel(
      name: name ?? this.name,
      legalName: legalName ?? this.legalName,
      domain: domain ?? this.domain,
      website: website ?? this.website,
      phone: phone ?? this.phone,
      companySize: companySize ?? this.companySize,
      foundedYear: foundedYear ?? this.foundedYear,
      workModel: workModel ?? this.workModel,
      shiftType: shiftType ?? this.shiftType,
      currency: currency ?? this.currency,
      salaryCycle: salaryCycle ?? this.salaryCycle,
      pfEnabled: pfEnabled ?? this.pfEnabled,
      pfPercentage: pfPercentage ?? this.pfPercentage,
      timezone: timezone ?? this.timezone,
      dateFormat: dateFormat ?? this.dateFormat,
      language: language ?? this.language,
      address1: address1 ?? this.address1,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      tanNumber: tanNumber ?? this.tanNumber,
      cinNumber: cinNumber ?? this.cinNumber,
      declared: declared ?? this.declared,
      companyLogo:companyLogo??this.companyLogo,
      signature:signature??this.signature

    
    );
  }
}
