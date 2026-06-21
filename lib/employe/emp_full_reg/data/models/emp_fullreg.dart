import 'dart:io';

class EmpFullRegModel {
  // ================= PERSONAL =================
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String dob;
  String maritalStatus;
  String bloodGroup;
  String nationality;

  // ================= CONTACT =================
  String personalEmail;
  String phone;
  String alternatePhone;
  String address;
  String city;
  String state;
  String country;
  String pincode;

  // ================= EMERGENCY =================
  String emergencyContactName;
  String emergencyRelation;
  String emergencyNumber;

  // ================= EDUCATION =================
  String degree;
  String specialization;
  String college;
  String university;
  String percentage;
  String startYear;
  String endYear;

  // ================= EXPERIENCE =================
  bool isexperienced;
  String companyName;
  String role;
  String experienceStartDate;
  String experienceEndDate;
  List<String> technologies;
  String responsibilities;

  // ================= SKILLS =================
  List<String> primarySkills;
  List<String> secondarySkills;
  List<String> certifications;
  List<String> languagesKnown;
  String linkedinUrl;
  String githubUrl;
  String portfolioUrl;

  // ================= BANK =================
  String bankName;
  String accountHolderName;
  String accountNumber;
  String ifscCode;
  String branchName;
  String upiId;

  // ================= NOMINEE =================
  String nomineeName;
  String nomineeRelation;
  String nomineeDob;
  String nomineeGender;
  String nomineePhone;
  String nomineeEmail;
  String nomineeAadhaar;
  String nomineePan;
  int nomineePercentage;
  String nomineeAddress;

  // ================= COMPLIANCE =================
  String uanNumber;
  String pfNumber;
  String esiNumber;

  bool isDeclaredTrue;

  // ================= DOCUMENT FILES =================
  File? aadhaar;
  File? pan;
  File? bankPassbook;
  File? educationProof;
  File? relievingLetter;
  File? payslips;
  File? profilePhoto;
  File? signature;
  File? passport;
  File? certificates;
  File? other;

  EmpFullRegModel({
    this.firstName = "",
    this.middleName = "",
    this.lastName = "",
    this.gender = "",
    this.dob = "",
    this.maritalStatus = "",
    this.bloodGroup = "",
    this.nationality = "",

    this.personalEmail = "",
    this.phone = "",
    this.alternatePhone = "",
    this.address = "",
    this.city = "",
    this.state = "",
    this.country = "",
    this.pincode = "",

    this.emergencyContactName = "",
    this.emergencyRelation = "",
    this.emergencyNumber = "",

    this.degree = "",
    this.specialization = "",
    this.college = "",
    this.university = "",
    this.percentage = "",
    this.startYear = "",
    this.endYear = "",
     
    this.isexperienced=false,
    this.companyName = "",
    this.role = "",
    this.experienceStartDate = "",
    this.experienceEndDate = "",
    this.technologies = const [],
    this.responsibilities = "",

    this.primarySkills = const [],
    this.secondarySkills = const [],
    this.certifications = const [],
    this.languagesKnown = const [],
    this.linkedinUrl = "",
    this.githubUrl = "",
    this.portfolioUrl = "",

    this.bankName = "",
    this.accountHolderName = "",
    this.accountNumber = "",
    this.ifscCode = "",
    this.branchName = "",
    this.upiId = "",

    this.nomineeName = "",
    this.nomineeRelation = "",
    this.nomineeDob = "",
    this.nomineeGender = "",
    this.nomineePhone = "",
    this.nomineeEmail = "",
    this.nomineeAadhaar = "",
    this.nomineePan = "",
    this.nomineePercentage = 0,
    this.nomineeAddress = "",

    this.uanNumber = "",
    this.pfNumber = "",
    this.esiNumber = "",

    this.isDeclaredTrue = false,

    this.aadhaar,
    this.pan,
    this.bankPassbook,
    this.educationProof,
    this.relievingLetter,
    this.payslips,
    this.profilePhoto,
    this.signature,
    this.passport,
    this.certificates,
    this.other,
  });

  // ================= COPY WITH =================
  EmpFullRegModel copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? gender,
    String? dob,
    String? maritalStatus,
    String? bloodGroup,
    String? nationality,

    String? personalEmail,
    String? phone,
    String? alternatePhone,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,

    String? emergencyContactName,
    String? emergencyRelation,
    String? emergencyNumber,

    String? degree,
    String? specialization,
    String? college,
    String? university,
    String? percentage,
    String? startYear,
    String? endYear,

    bool?isexperienced,
    String? companyName,
    String? role,
    String? experienceStartDate,
    String? experienceEndDate,
    List<String>? technologies,
    String? responsibilities,

    List<String>? primarySkills,
    List<String>? secondarySkills,
    List<String>? certifications,
    List<String>? languagesKnown,
    String? linkedinUrl,
    String? githubUrl,
    String? portfolioUrl,

    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    String? branchName,
    String? upiId,

    String? nomineeName,
    String? nomineeRelation,
    String? nomineeDob,
    String? nomineeGender,
    String? nomineePhone,
    String? nomineeEmail,
    String? nomineeAadhaar,
    String? nomineePan,
    int? nomineePercentage,
    String? nomineeAddress,

    String? uanNumber,
    String? pfNumber,
    String? esiNumber,

    bool? isDeclaredTrue,

    File? aadhaar,
    File? pan,
    File? bankPassbook,
    File? educationProof,
    File? relievingLetter,
    File? payslips,
    File? profilePhoto,
    File? signature,
    File? passport,
    File? certificates,
    File? other,
  }) {
    return EmpFullRegModel(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      nationality: nationality ?? this.nationality,

      personalEmail: personalEmail ?? this.personalEmail,
      phone: phone ?? this.phone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,

      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyRelation: emergencyRelation ?? this.emergencyRelation,
      emergencyNumber: emergencyNumber ?? this.emergencyNumber,

      degree: degree ?? this.degree,
      specialization: specialization ?? this.specialization,
      college: college ?? this.college,
      university: university ?? this.university,
      percentage: percentage ?? this.percentage,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
       
       isexperienced:isexperienced??this.isexperienced,
      companyName: companyName ?? this.companyName,
      role: role ?? this.role,
      experienceStartDate: experienceStartDate ?? this.experienceStartDate,
      experienceEndDate: experienceEndDate ?? this.experienceEndDate,
      technologies: technologies ?? this.technologies,
      responsibilities: responsibilities ?? this.responsibilities,

      primarySkills: primarySkills ?? this.primarySkills,
      secondarySkills: secondarySkills ?? this.secondarySkills,
      certifications: certifications ?? this.certifications,
      languagesKnown: languagesKnown ?? this.languagesKnown,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,

      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      branchName: branchName ?? this.branchName,
      upiId: upiId ?? this.upiId,

      nomineeName: nomineeName ?? this.nomineeName,
      nomineeRelation: nomineeRelation ?? this.nomineeRelation,
      nomineeDob: nomineeDob ?? this.nomineeDob,
      nomineeGender: nomineeGender ?? this.nomineeGender,
      nomineePhone: nomineePhone ?? this.nomineePhone,
      nomineeEmail: nomineeEmail ?? this.nomineeEmail,
      nomineeAadhaar: nomineeAadhaar ?? this.nomineeAadhaar,
      nomineePan: nomineePan ?? this.nomineePan,
      nomineePercentage: nomineePercentage ?? this.nomineePercentage,
      nomineeAddress: nomineeAddress ?? this.nomineeAddress,

      uanNumber: uanNumber ?? this.uanNumber,
      pfNumber: pfNumber ?? this.pfNumber,
      esiNumber: esiNumber ?? this.esiNumber,

      isDeclaredTrue: isDeclaredTrue ?? this.isDeclaredTrue,

      aadhaar: aadhaar ?? this.aadhaar,
      pan: pan ?? this.pan,
      bankPassbook: bankPassbook ?? this.bankPassbook,
      educationProof: educationProof ?? this.educationProof,
      relievingLetter: relievingLetter ?? this.relievingLetter,
      payslips: payslips ?? this.payslips,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      signature: signature ?? this.signature,
      passport: passport ?? this.passport,
      certificates: certificates ?? this.certificates,
      other: other ?? this.other,
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      "personal": {
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "gender": gender,
        "dob": dob,
        "maritalStatus": maritalStatus,
        "bloodGroup": bloodGroup,
        "nationality": nationality,
      },
      "contact": {
        "personalEmail": personalEmail,
        "phone": phone,
        "alternatePhone": alternatePhone,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
      },
      "emergency": [
        {
          "contactPersonName": emergencyContactName,
          "relationship": emergencyRelation,
          "contactNumber": emergencyNumber,
        },
      ],
      "education": [
        {
          "degree": degree,
          "specialization": specialization,
          "college": college,
          "university": university,
          "percentage": percentage,
          "startYear": startYear,
          "endYear": endYear,
        },
      ],
      "experience": [
        {
          "companyName": companyName,
          "role": role,
          "startDate": experienceStartDate,
          "endDate": experienceEndDate,
          "technologies": technologies,
          "responsibilities": responsibilities,
        },
      ],
      "skills": {
        "primarySkills": primarySkills,
        "secondarySkills": secondarySkills,
        "certifications": certifications,
        "languagesKnown": languagesKnown,
      },
      "bank": {
        "bankName": bankName,
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "branchName": branchName,
        "upiId": upiId,
      },
      "nominee": {
        "nomineeName": nomineeName,
        "relationship": nomineeRelation,
        "dob": nomineeDob,
        "gender": nomineeGender,
        "phone": nomineePhone,
        "email": nomineeEmail,
        "aadhaarNumber": nomineeAadhaar,
        "panNumber": nomineePan,
        "nomineePercentage": nomineePercentage,
        "address": nomineeAddress,
      },
      "compliance": {
        "uanNumber": uanNumber,
        "pfNumber": pfNumber,
        "esiNumber": esiNumber,
      },
      "isDeclaredTrue": isDeclaredTrue,
      "documents": {
        "aadhaar": aadhaar?.path,
        "pan": pan?.path,
        "bankPassbook": bankPassbook?.path,
        "education_proof": educationProof?.path,
        "relieving_letter": relievingLetter?.path,
        "payslips": payslips?.path,
        "profilePhoto": profilePhoto?.path,
        "signature": signature?.path,
        "passport": passport?.path,
        "certificates": certificates?.path,
        "other": other?.path,
      },
    };
  }
}
