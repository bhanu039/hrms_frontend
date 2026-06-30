import 'package:dio/dio.dart';
import 'package:goexperts/core/services/api_client.dart';

class OnboardingRepository {
  /// API 1: GET /api/onboarding/review/:employeeId
  /// Fetches the complete profile and verification document list
  Future<Map<String, dynamic>> getEmployeeReviewData(String employeeId) async {
    try {
      print(employeeId);
      final response = await ApiClient.dio.get(
        'api/onboarding/review/$employeeId',
      );print(response);

      if (response.statusCode == 200) {
        print(response);
        return response.data as Map<String, dynamic>;
      } else {
        print(response);
        throw Exception('Failed to load profile evaluation files');
      }
    } on DioException catch (e) {
      final String errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Network Error';
      print(errorMsg);
      throw Exception(errorMsg);
    }
  }

  /// API 2: POST /api/onboarding/document-status
  /// Updates the lifecycle evaluation status of a single proof item
  Future<bool> updateDocumentStatus({
    required String documentId,
    required String status, // "APPROVED" or "REJECTED"
    required String remarks,
  }) async {
    try {
      final response = await ApiClient.dio.post(
        'api/onboarding/document-status',
        data: {"documentId": documentId, "status": status, "remarks": remarks},
      );

      // Return true if the server commits the state mutation smoothly
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      final String errorMsg =
          e.response?.data?['message'] ?? e.message ?? 'Update Failed';
      throw Exception(errorMsg);
    }
  }
}
