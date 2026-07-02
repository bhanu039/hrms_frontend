import 'package:dio/dio.dart';

import '../../../core/services/api_client.dart';

class IndustryRepository {
  // 1. GET ALL INDUSTRY TYPES
  Future<dynamic> getAllIndustryTypes() async {
    try {
      final response = await ApiClient.dio.get("/api/master/industries");
      return response.data;
    }
     catch (e) {
      throw Exception("Failed to retrieve industry types: $e");
    }
  }

  // 2. ADD NEW INDUSTRY TYPE (POST)
  Future<Response> createIndustryType(String name) async {
    try {
      final response = await ApiClient.dio.post(
        "/api/master/industry/create",
        data: {"name": name},
      );
     return response;
      
    } catch (e) {
      throw Exception("Network operations failure: $e");
    }
  }

  // 3. EDIT LEAVE TYPE (PUT -> /api/leaves/types/:IndustryTypeId)
  Future<Response> updateIndustryType(
    String id,
    String name,
  ) async {
    try {
      final response = await ApiClient.dio.put(
        "/api/leaves/types/$id",
        data: {"name": name},
      );
    
        return response;
      
    } catch (e) {
      throw Exception("Network update channel failure: $e");
    }
  }

  // 4. DELETE LEAVE TYPE (DELETE -> /api/leaves/types/:IndustryTypeId)
  Future<Response> deleteIndustryType(String id) async {
    try {
      final response = await ApiClient.dio.delete("/api/leaves/types/$id");
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Server responded with code ${response.statusCode}");
      }
      return response;
    } catch (e) {
      throw Exception("Network deletion channel error: $e");
    }
  }
}
