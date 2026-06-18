import 'package:dio/dio.dart';
import 'package:goexperts/core/services/api_client.dart';

import 'models/emp_fullreg.dart';


class EmpFullRegRepository {
  final Dio _dio = ApiClient.dio;

  /// Submit employee onboarding form to the API
  Future<Response> submitOnboarding(EmpFullRegModel model) async {
    try {
      final formData = FormData();

      // ================= JSON DATA PART =================
      formData.fields.add(MapEntry("data", model.toJson().toString()));

      // ================= FILE UPLOADS =================
      if (model.aadhaar != null) {
        formData.files.add(
          MapEntry(
            "aadhaar",
            await MultipartFile.fromFile(model.aadhaar!.path),
          ),
        );
      }

      if (model.pan != null) {
        formData.files.add(
          MapEntry("pan", await MultipartFile.fromFile(model.pan!.path)),
        );
      }

      if (model.bankPassbook != null) {
        formData.files.add(
          MapEntry(
            "bankPassbook",
            await MultipartFile.fromFile(model.bankPassbook!.path),
          ),
        );
      }

      if (model.educationProof != null) {
        formData.files.add(
          MapEntry(
            "educationProof",
            await MultipartFile.fromFile(model.educationProof!.path),
          ),
        );
      }

      if (model.relievingLetter != null) {
        formData.files.add(
          MapEntry(
            "relievingLetter",
            await MultipartFile.fromFile(model.relievingLetter!.path),
          ),
        );
      }

      if (model.payslips != null) {
        formData.files.add(
          MapEntry(
            "payslips",
            await MultipartFile.fromFile(model.payslips!.path),
          ),
        );
      }

      if (model.profilePhoto != null) {
        formData.files.add(
          MapEntry(
            "profilePhoto",
            await MultipartFile.fromFile(model.profilePhoto!.path),
          ),
        );
      }

      if (model.signature != null) {
        formData.files.add(
          MapEntry(
            "signature",
            await MultipartFile.fromFile(model.signature!.path),
          ),
        );
      }

      if (model.passport != null) {
        formData.files.add(
          MapEntry(
            "passport",
            await MultipartFile.fromFile(model.passport!.path),
          ),
        );
      }

      if (model.certificates != null) {
        formData.files.add(
          MapEntry(
            "certificates",
            await MultipartFile.fromFile(model.certificates!.path),
          ),
        );
      }

      if (model.other != null) {
        formData.files.add(
          MapEntry("other", await MultipartFile.fromFile(model.other!.path)),
        );
      }

      // ================= API CALL =================
      final response = await _dio.put("/api/onboarding/finish", data: formData);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
