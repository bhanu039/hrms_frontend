import 'package:dio/dio.dart';
import 'package:goexperts/core/services/api_client.dart';
import '../modal/full_Reg_modal.dart';

class FullRegRepository {

  Future<Response> submit(FullRegModel m) async {

    final formData = FormData.fromMap({

      // BASIC
      "legalName": m.legalName,
      "phone": m.phone,
      "website": m.website,
      "linkedinUrl": m.linkedinUrl,
      "companySize": m.companySize,
      "foundedYear": m.foundedYear,
      "cinNumber": m.cinNumber,

      // ADDRESS
      "address": m.address1,
      "city": m.city,
      "state": m.state,
      "country": m.country,
      "pincode": m.pincode,
      "landmark": m.landmark,
      "latitude": m.latitude,
      "longitude": m.longitude,
      "geofencRadius":m.geofencRadius,

      // HR
      "companyPolicy": m.companyPolicy,
      "employeeTerms": m.employeeTerms,
      "workingHours": m.workingHours,
      "workingDays": m.workingDays,
      "workModel": m.workModel,
      "shiftType": m.shiftType,

      // TAX
      "gstNumber": m.gstNumber,
      "panNumber": m.panNumber,
      "tanNumber": m.tanNumber,
      "pfEnabled": m.pfEnabled.toString(),
      "pfPercentage": m.pfPercentage,
      "pfRegistrationNumber": m.pfRegistrationNumber,
      "esiEnabled": m.esiEnabled.toString(),
      "esiRegistrationNumber": m.esiRegistrationNumber,
      "ptRegistrationNumber": m.ptRegistrationNumber,

      // PAYROLL
      "currency": m.currency,
      "salaryCycle": m.salaryCycle,
      "payrollStartDay": m.payrollStartDay,
      "payrollEndDay": m.payrollEndDay,
      "termsAndConditions": m.termsAndConditions,

      // FINAL
      "declared": m.declared.toString(),
    });

    Future<void> addFile(String key, file) async {
      if (file != null) {
        formData.files.add(
          MapEntry(
            key,
            await MultipartFile.fromFile(file.path),
          ),
        );
      }
    }

    // FILES (FIXED MAPPING)
    await addFile("logo", m.companyLogo);
    await addFile("signature", m.signature);
    await addFile("regCertificate", m.regCertificate);
    await addFile("gstProof", m.gstProof);
    await addFile("panProof", m.panProof);
    await addFile("tanProof", m.tanProof);

    return await ApiClient.dio.put(
      "/api/company/profile",
      data: formData,
    );
  }
}