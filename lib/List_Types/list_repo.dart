import 'package:dio/dio.dart';

import '../core/services/api_client.dart';

class ListRepository {
  // 1. GET ALL INDUSTRY TYPES
  Future<dynamic> getAllListTypes(String listType, String? listTypeid) async {
    try {
      final endpoint = listType == "industry"
          ? "/api/master/industries"
          : listType == "departments"
          ? "/api/master/departments?industryTypeId=$listTypeid"
          : "/api/master/designations?departmentId=$listTypeid";
      final response = await ApiClient.dio.get(endpoint);
      return response.data;
    } catch (e) {
      throw Exception("Failed to retrieve list types: $e");
    }
  }

  // 2. ADD NEW INDUSTRY TYPE (POST)
  Future<Response> createListType(
    String name,
    String listType,
    String? listTypeid,
  ) async {
    try {
      final endpoint = listType == "industry"
          ? "/api/master/industry/create"
          : (listType == "departments" || listType == "department")
          ? "/api/master/department/add"
          : "/api/master/designation/add";
      final response = await ApiClient.dio.post(
        endpoint,
        data: {
          if (listType == "departments" || listType == "department")
            'industryTypeId': listTypeid,
          if (listType == "designations" || listType == "designation")
            'departmentsId': listTypeid,
          "name": name,
        },
      );
      return response;
    } catch (e) {
      throw Exception("Network operations failure: $e");
    }
  }

  // 3. EDIT LIST TYPE (PUT -> /api/master/:resource/:id)
  Future<Response> updateListType(
    String listType,
    String id,
    String name,
  ) async {
    try {
      final endpoint = listType == "industry"
          ? "/api/master/industries/$id"
          : (listType == "departments" || listType == "department")
          ? "/api/master/department/$id"
          : "/api/master/designation/$id";

      final response = await ApiClient.dio.put(endpoint, data: {"name": name});

      return response;
    } catch (e) {
      throw Exception("Network update channel failure: $e");
    }
  }

  // 4. DELETE LIST TYPE (DELETE -> /api/master/:resource/:id)
  Future<Response> deleteListType(String id, String listType) async {
    try {
      final endpoint = listType == "industry"
          ? "/api/master/industries/$id"
          : (listType == "departments" || listType == "department")
          ? "/api/master/department/$id"
          : "/api/master/designation/$id";
      final response = await ApiClient.dio.delete(endpoint);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Server responded with code ${response.statusCode}");
      }
      return response;
    } catch (e) {
      throw Exception("Network deletion channel error: $e");
    }
  }
}
