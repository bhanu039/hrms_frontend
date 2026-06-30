import 'dart:io';

class FullRegModel {
  // BASIC
  final String legalName;
  final String phone;
  final String website;
  final String linkedinUrl;
  final String companySize;
  final String foundedYear;
  final String cinNumber;

  // ADDRESS
  final String address1;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final String landmark;
  final double? latitude;
  final double? longitude;
  final int? geofenceRadius;

  // HR
  final String companyPolicy;
  final String employeeTerms;
  final String workingHours;
  final String workingDays;
  final String workModel;
  final String shiftType;

  // TAX
  final String gstNumber;
  final String panNumber;
  final String tanNumber;
  final bool pfEnabled;
  final String pfPercentage;
  final String pfRegistrationNumber;
  final bool esiEnabled;
  final String esiRegistrationNumber;
  final String ptRegistrationNumber;

  // PAYROLL
  final String currency;
  final String salaryCycle;
  final String payrollStartDay;
  final String payrollEndDay;
  final String termsAndConditions;

  // FILES
  final File? companyLogo;
  final File? signature;
  final File? regCertificate;
  final File? gstProof;
  final File? panProof;
  final File? tanProof;

  // EXTRA
  final bool declared;

  const FullRegModel({
    this.legalName = "",
    this.phone = "",
    this.website = "",
    this.linkedinUrl = "",
    this.companySize = "",
    this.foundedYear = "",
    this.cinNumber = "",

    this.address1 = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.pincode = "",
    this.landmark = "",
    this.latitude,
    this.longitude,
    this.geofenceRadius,

    this.companyPolicy = "",
    this.employeeTerms = "",
    this.workingHours = "",
    this.workingDays = "",
    this.workModel = "",
    this.shiftType = "",

    this.gstNumber = "",
    this.panNumber = "",
    this.tanNumber = "",
    this.pfEnabled = false,
    this.pfPercentage = "",
    this.pfRegistrationNumber = "",
    this.esiEnabled = false,
    this.esiRegistrationNumber = "",
    this.ptRegistrationNumber = "",

    this.currency = "",
    this.salaryCycle = "",
    this.payrollStartDay = "",
    this.payrollEndDay = "",
    this.termsAndConditions = "",

    this.companyLogo,
    this.signature,
    this.regCertificate,
    this.gstProof,
    this.panProof,
    this.tanProof,

    this.declared = false,
  });

  FullRegModel copyWith({
    String? legalName,
    String? phone,
    String? website,
    String? linkedinUrl,
    String? companySize,
    String? foundedYear,
    String? cinNumber,

    String? address1,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? landmark,
    double? latitude,
    double? longitude,
    int? geofenceRadius,

    String? companyPolicy,
    String? employeeTerms,
    String? workingHours,
    String? workingDays,
    String? workModel,
    String? shiftType,

    String? gstNumber,
    String? panNumber,
    String? tanNumber,
    bool? pfEnabled,
    String? pfPercentage,
    String? pfRegistrationNumber,
    bool? esiEnabled,
    String? esiRegistrationNumber,
    String? ptRegistrationNumber,

    String? currency,
    String? salaryCycle,
    String? payrollStartDay,
    String? payrollEndDay,
    String? termsAndConditions,

    File? companyLogo,
    File? signature,
    File? regCertificate,
    File? gstProof,
    File? panProof,
    File? tanProof,

    bool? declared,
  }) {
    return FullRegModel(
      legalName: legalName ?? this.legalName,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      companySize: companySize ?? this.companySize,
      foundedYear: foundedYear ?? this.foundedYear,
      cinNumber: cinNumber ?? this.cinNumber,

      address1: address1 ?? this.address1,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      geofenceRadius: geofenceRadius ?? this.geofenceRadius,

      companyPolicy: companyPolicy ?? this.companyPolicy,
      employeeTerms: employeeTerms ?? this.employeeTerms,
      workingHours: workingHours ?? this.workingHours,
      workingDays: workingDays ?? this.workingDays,
      workModel: workModel ?? this.workModel,
      shiftType: shiftType ?? this.shiftType,

      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      tanNumber: tanNumber ?? this.tanNumber,
      pfEnabled: pfEnabled ?? this.pfEnabled,
      pfPercentage: pfPercentage ?? this.pfPercentage,
      pfRegistrationNumber: pfRegistrationNumber ?? this.pfRegistrationNumber,
      esiEnabled: esiEnabled ?? this.esiEnabled,
      esiRegistrationNumber:
          esiRegistrationNumber ?? this.esiRegistrationNumber,
      ptRegistrationNumber: ptRegistrationNumber ?? this.ptRegistrationNumber,

      currency: currency ?? this.currency,
      salaryCycle: salaryCycle ?? this.salaryCycle,
      payrollStartDay: payrollStartDay ?? this.payrollStartDay,
      payrollEndDay: payrollEndDay ?? this.payrollEndDay,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,

      companyLogo: companyLogo ?? this.companyLogo,
      signature: signature ?? this.signature,
      regCertificate: regCertificate ?? this.regCertificate,
      gstProof: gstProof ?? this.gstProof,
      panProof: panProof ?? this.panProof,
      tanProof: tanProof ?? this.tanProof,

      declared: declared ?? this.declared,
    );
  }
}
