import 'dart:convert';

import '../../../core/services/api_client.dart';
import 'leave_type_modal.dart';

class LeaveTypeRepository {


  // 1. GET ALL LEAVE TYPES
  Future<List<LeaveTypeModel>> getAllLeaveTypes() async {
    try {
      final response = await ApiClient.dio.get("/api/leaves/types");
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.data);
        if (decoded['success'] == true && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((json) => LeaveTypeModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw Exception("Server responded with code ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to retrieve leave listings: $e");
    }
  }

  // 2. ADD NEW LEAVE TYPE (POST)
  Future<LeaveTypeModel> createLeaveType(String name, int maxDays) async {
    try {
      final response = await ApiClient.dio.post(
        "/api/leaves/types",
        data: {"name": name, "maxDays": maxDays}
      );
      final Map<String, dynamic> decoded = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (decoded['success'] == true && decoded['data'] != null) {
          return LeaveTypeModel.fromJson(decoded['data'] as Map<String, dynamic>);
        }
        return LeaveTypeModel.fromJson(decoded);
      } else {
        throw Exception(decoded['message'] ?? "Failed to create leave registry.");
      }
    } catch (e) {
      throw Exception("Network operations failure: $e");
    }
  }

  // 3. EDIT LEAVE TYPE (PUT -> /api/leaves/types/:leaveTypeId)
  Future<LeaveTypeModel> updateLeaveType(String id, String name, int maxDays) async {
    try {
      final response = await ApiClient.dio.put(
        "/api/leaves/types/$id",
        data: {"name": name, "maxDays": maxDays}
      );
      final Map<String, dynamic> decoded = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Fallback check matching varying wrapped schema payloads
        if (decoded['data'] != null) {
          return LeaveTypeModel.fromJson(decoded['data'] as Map<String, dynamic>);
        }
        return LeaveTypeModel.fromJson(decoded);
      } else {
        throw Exception(decoded['message'] ?? "Failed to update record configuration.");
      }
    } catch (e) {
      throw Exception("Network update channel failure: $e");
    }
  }

  // 4. DELETE LEAVE TYPE (DELETE -> /api/leaves/types/:leaveTypeId)
  Future<void> deleteLeaveType(String id) async {
    try {
      final response = await ApiClient.dio.delete("/api/leaves/types/$id");
      if (response.statusCode != 200 && response.statusCode != 204) {
        final Map<String, dynamic> decoded = jsonDecode(response.data);
        throw Exception(decoded['message'] ?? "Failed to delete target registry entry.");
      }
    } catch (e) {
      throw Exception("Network deletion channel error: $e");
    }
  }
}
