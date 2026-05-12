// To parse this JSON data, do
//
//     final employeeDataModel = employeeDataModelFromJson(jsonString);

import 'dart:convert';

EmployeeDataModel employeeDataModelFromJson(String str) => EmployeeDataModel.fromJson(json.decode(str));

String employeeDataModelToJson(EmployeeDataModel data) => json.encode(data.toJson());

class EmployeeDataModel {
    String id;
    String userId;
    String companyId;
    String employeeCode;
    String firstName;
    String lastName;
    String middleName;
    String profilePhoto;
    int onboardingStep;
    bool onboardingCompleted;
    String departmentId;
    String designationId;
    DateTime joiningDate;
    String employmentType;
    dynamic workLocation;
    dynamic managerId;
    String status;
    String bgvStatus;
    dynamic bgvRemarks;
    dynamic deletedAt;
    User user;
    Department department;
    Designation designation;
    List<Education> education;
    List<Experience> experience;
    Skills skills;
    List<Document> documents;
    BankDetails bankDetails;
    Nominee nominee;
    Compliance compliance;

    EmployeeDataModel({
        required this.id,
        required this.userId,
        required this.companyId,
        required this.employeeCode,
        required this.firstName,
        required this.lastName,
        required this.middleName,
        required this.profilePhoto,
        required this.onboardingStep,
        required this.onboardingCompleted,
        required this.departmentId,
        required this.designationId,
        required this.joiningDate,
        required this.employmentType,
        required this.workLocation,
        required this.managerId,
        required this.status,
        required this.bgvStatus,
        required this.bgvRemarks,
        required this.deletedAt,
        required this.user,
        required this.department,
        required this.designation,
        required this.education,
        required this.experience,
        required this.skills,
        required this.documents,
        required this.bankDetails,
        required this.nominee,
        required this.compliance,
    });

    factory EmployeeDataModel.fromJson(Map<String, dynamic> json) => EmployeeDataModel(
        id: json["id"],
        userId: json["userId"],
        companyId: json["companyId"],
        employeeCode: json["employeeCode"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        middleName: json["middleName"],
        profilePhoto: json["profilePhoto"],
        onboardingStep: json["onboardingStep"],
        onboardingCompleted: json["onboardingCompleted"],
        departmentId: json["departmentId"],
        designationId: json["designationId"],
        joiningDate: DateTime.parse(json["joiningDate"]),
        employmentType: json["employmentType"],
        workLocation: json["workLocation"],
        managerId: json["managerId"],
        status: json["status"],
        bgvStatus: json["bgvStatus"],
        bgvRemarks: json["bgvRemarks"],
        deletedAt: json["deletedAt"],
        user: User.fromJson(json["user"]),
        department: Department.fromJson(json["department"]),
        designation: Designation.fromJson(json["designation"]),
        education: List<Education>.from(json["education"].map((x) => Education.fromJson(x))),
        experience: List<Experience>.from(json["experience"].map((x) => Experience.fromJson(x))),
        skills: Skills.fromJson(json["skills"]),
        documents: List<Document>.from(json["documents"].map((x) => Document.fromJson(x))),
        bankDetails: BankDetails.fromJson(json["bankDetails"]),
        nominee: Nominee.fromJson(json["nominee"]),
        compliance: Compliance.fromJson(json["compliance"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "companyId": companyId,
        "employeeCode": employeeCode,
        "firstName": firstName,
        "lastName": lastName,
        "middleName": middleName,
        "profilePhoto": profilePhoto,
        "onboardingStep": onboardingStep,
        "onboardingCompleted": onboardingCompleted,
        "departmentId": departmentId,
        "designationId": designationId,
        "joiningDate": joiningDate.toIso8601String(),
        "employmentType": employmentType,
        "workLocation": workLocation,
        "managerId": managerId,
        "status": status,
        "bgvStatus": bgvStatus,
        "bgvRemarks": bgvRemarks,
        "deletedAt": deletedAt,
        "user": user.toJson(),
        "department": department.toJson(),
        "designation": designation.toJson(),
        "education": List<dynamic>.from(education.map((x) => x.toJson())),
        "experience": List<dynamic>.from(experience.map((x) => x.toJson())),
        "skills": skills.toJson(),
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
        "bankDetails": bankDetails.toJson(),
        "nominee": nominee.toJson(),
        "compliance": compliance.toJson(),
    };
}

class BankDetails {
    String id;
    String employeeId;
    String bankName;
    String accountHolderName;
    String accountNumber;
    String ifscCode;
    String branchName;
    String upiId;

    BankDetails({
        required this.id,
        required this.employeeId,
        required this.bankName,
        required this.accountHolderName,
        required this.accountNumber,
        required this.ifscCode,
        required this.branchName,
        required this.upiId,
    });

    factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
        id: json["id"],
        employeeId: json["employeeId"],
        bankName: json["bankName"],
        accountHolderName: json["accountHolderName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        branchName: json["branchName"],
        upiId: json["upiId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "bankName": bankName,
        "accountHolderName": accountHolderName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "branchName": branchName,
        "upiId": upiId,
    };
}

class Compliance {
    String id;
    String employeeId;
    String pfNumber;
    String esiNumber;
    String uanNumber;
    dynamic insuranceId;
    dynamic insuranceProvider;
    dynamic policyNumber;
    dynamic coverageAmount;
    dynamic policyStartDate;
    dynamic policyEndDate;
    DateTime createdAt;

    Compliance({
        required this.id,
        required this.employeeId,
        required this.pfNumber,
        required this.esiNumber,
        required this.uanNumber,
        required this.insuranceId,
        required this.insuranceProvider,
        required this.policyNumber,
        required this.coverageAmount,
        required this.policyStartDate,
        required this.policyEndDate,
        required this.createdAt,
    });

    factory Compliance.fromJson(Map<String, dynamic> json) => Compliance(
        id: json["id"],
        employeeId: json["employeeId"],
        pfNumber: json["pfNumber"],
        esiNumber: json["esiNumber"],
        uanNumber: json["uanNumber"],
        insuranceId: json["insuranceId"],
        insuranceProvider: json["insuranceProvider"],
        policyNumber: json["policyNumber"],
        coverageAmount: json["coverageAmount"],
        policyStartDate: json["policyStartDate"],
        policyEndDate: json["policyEndDate"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "pfNumber": pfNumber,
        "esiNumber": esiNumber,
        "uanNumber": uanNumber,
        "insuranceId": insuranceId,
        "insuranceProvider": insuranceProvider,
        "policyNumber": policyNumber,
        "coverageAmount": coverageAmount,
        "policyStartDate": policyStartDate,
        "policyEndDate": policyEndDate,
        "createdAt": createdAt.toIso8601String(),
    };
}

class Department {
    String id;
    String name;
    String companyId;

    Department({
        required this.id,
        required this.name,
        required this.companyId,
    });

    factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["id"],
        name: json["name"],
        companyId: json["companyId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "companyId": companyId,
    };
}

class Designation {
    String id;
    String title;
    int level;
    String companyId;

    Designation({
        required this.id,
        required this.title,
        required this.level,
        required this.companyId,
    });

    factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        id: json["id"],
        title: json["title"],
        level: json["level"],
        companyId: json["companyId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "level": level,
        "companyId": companyId,
    };
}

class Document {
    String id;
    String employeeId;
    String name;
    String fileUrl;
    String status;
    dynamic remarks;
    DateTime createdAt;

    Document({
        required this.id,
        required this.employeeId,
        required this.name,
        required this.fileUrl,
        required this.status,
        required this.remarks,
        required this.createdAt,
    });

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        employeeId: json["employeeId"],
        name: json["name"],
        fileUrl: json["fileUrl"],
        status: json["status"],
        remarks: json["remarks"],
        createdAt: DateTime.parse(json["createdAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "name": name,
        "fileUrl": fileUrl,
        "status": status,
        "remarks": remarks,
        "createdAt": createdAt.toIso8601String(),
    };
}

class Education {
    String id;
    String employeeId;
    String degree;
    String specialization;
    String college;
    String university;
    String? percentage;
    String? cgpa;
    String startYear;
    String endYear;

    Education({
        required this.id,
        required this.employeeId,
        required this.degree,
        required this.specialization,
        required this.college,
        required this.university,
        required this.percentage,
        required this.cgpa,
        required this.startYear,
        required this.endYear,
    });

    factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json["id"],
        employeeId: json["employeeId"],
        degree: json["degree"],
        specialization: json["specialization"],
        college: json["college"],
        university: json["university"],
        percentage: json["percentage"],
        cgpa: json["cgpa"],
        startYear: json["startYear"],
        endYear: json["endYear"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "degree": degree,
        "specialization": specialization,
        "college": college,
        "university": university,
        "percentage": percentage,
        "cgpa": cgpa,
        "startYear": startYear,
        "endYear": endYear,
    };
}

class Experience {
    String id;
    String employeeId;
    String companyName;
    String role;
    DateTime startDate;
    DateTime endDate;
    String technologies;
    String responsibilities;
    double totalYears;

    Experience({
        required this.id,
        required this.employeeId,
        required this.companyName,
        required this.role,
        required this.startDate,
        required this.endDate,
        required this.technologies,
        required this.responsibilities,
        required this.totalYears,
    });

    factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        id: json["id"],
        employeeId: json["employeeId"],
        companyName: json["companyName"],
        role: json["role"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        technologies: json["technologies"],
        responsibilities: json["responsibilities"],
        totalYears: json["totalYears"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "companyName": companyName,
        "role": role,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "technologies": technologies,
        "responsibilities": responsibilities,
        "totalYears": totalYears,
    };
}

class Nominee {
    String id;
    String employeeId;
    String nomineeName;
    String relationship;
    DateTime dob;
    String gender;
    String phone;
    String email;
    String aadhaarNumber;
    String panNumber;
    int nomineePercentage;
    String address;

    Nominee({
        required this.id,
        required this.employeeId,
        required this.nomineeName,
        required this.relationship,
        required this.dob,
        required this.gender,
        required this.phone,
        required this.email,
        required this.aadhaarNumber,
        required this.panNumber,
        required this.nomineePercentage,
        required this.address,
    });

    factory Nominee.fromJson(Map<String, dynamic> json) => Nominee(
        id: json["id"],
        employeeId: json["employeeId"],
        nomineeName: json["nomineeName"],
        relationship: json["relationship"],
        dob: DateTime.parse(json["dob"]),
        gender: json["gender"],
        phone: json["phone"],
        email: json["email"],
        aadhaarNumber: json["aadhaarNumber"],
        panNumber: json["panNumber"],
        nomineePercentage: json["nomineePercentage"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "nomineeName": nomineeName,
        "relationship": relationship,
        "dob": dob.toIso8601String(),
        "gender": gender,
        "phone": phone,
        "email": email,
        "aadhaarNumber": aadhaarNumber,
        "panNumber": panNumber,
        "nomineePercentage": nomineePercentage,
        "address": address,
    };
}

class Skills {
    String id;
    String employeeId;
    List<String> primarySkills;
    List<String> secondarySkills;
    List<String> certifications;
    List<String> languagesKnown;
    String linkedinUrl;
    String githubUrl;
    String portfolioUrl;

    Skills({
        required this.id,
        required this.employeeId,
        required this.primarySkills,
        required this.secondarySkills,
        required this.certifications,
        required this.languagesKnown,
        required this.linkedinUrl,
        required this.githubUrl,
        required this.portfolioUrl,
    });

    factory Skills.fromJson(Map<String, dynamic> json) => Skills(
        id: json["id"],
        employeeId: json["employeeId"],
        primarySkills: List<String>.from(json["primarySkills"].map((x) => x)),
        secondarySkills: List<String>.from(json["secondarySkills"].map((x) => x)),
        certifications: List<String>.from(json["certifications"].map((x) => x)),
        languagesKnown: List<String>.from(json["languagesKnown"].map((x) => x)),
        linkedinUrl: json["linkedinUrl"],
        githubUrl: json["githubUrl"],
        portfolioUrl: json["portfolioUrl"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "primarySkills": List<dynamic>.from(primarySkills.map((x) => x)),
        "secondarySkills": List<dynamic>.from(secondarySkills.map((x) => x)),
        "certifications": List<dynamic>.from(certifications.map((x) => x)),
        "languagesKnown": List<dynamic>.from(languagesKnown.map((x) => x)),
        "linkedinUrl": linkedinUrl,
        "githubUrl": githubUrl,
        "portfolioUrl": portfolioUrl,
    };
}

class User {
    String name;
    String email;
    String status;

    User({
        required this.name,
        required this.email,
        required this.status,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "status": status,
    };
}
