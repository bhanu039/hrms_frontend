import 'package:dio/dio.dart';

import '../../../core/services/api_client.dart';

class AddCompanyRepository {
  Future<List<Map<String, dynamic>>> getIndustries() async {
    final res = await ApiClient.dio.get("api/master/industries");

    return List<Map<String, dynamic>>.from(res.data["data"]);
  }

  Future<Map<String, dynamic>> createCompany({
    required String name,
    required String email,
    required String location,
    required String ownerName,
    required String ownerEmail,
    required String industryId,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        "api/company/create",
        data: {
          "name": name,
          "email": email,
          "location": location,
          "owner_name": ownerName,
          "owner_email": ownerEmail,
          "industry_id": industryId,
        },
         options: Options(validateStatus: (status) => true),
      );

      return res.data;
    } catch (e) {
     if (e is DioError) {
        return {"success": false, "message": e.message};
      }
      return {"success": false, "message": e.toString()};
    }
  }
}
