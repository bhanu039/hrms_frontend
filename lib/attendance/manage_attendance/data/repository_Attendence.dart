import 'package:dio/dio.dart';
import 'package:goexperts/core/services/api_client.dart';

import 'attendance_model.dart';

class AttendenceRepository {
Future<AttendanceResponse> getEmployeesAttendance({
  required int currentPage,
  String? search,
  String? status,
  String? fromDate,
  String? toDate,
}) async {
  try {
    final response = await ApiClient.dio.get(
      '/api/attendance/company',
      queryParameters: {
        'currentPage': currentPage,
        'page_size': 20,
        if (search?.isNotEmpty ?? false) 'search': search,
        if (status?.isNotEmpty ?? false) 'status': status,
        if (fromDate?.isNotEmpty ?? false) 'from_date': fromDate,
        if (toDate?.isNotEmpty ?? false) 'to_date': toDate,
      },
    );

    final responseData = response.data is Map<String, dynamic>
        ? response.data['data'] ?? response.data
        : response.data;

    return AttendanceResponse.fromJson(
      responseData is Map<String, dynamic>
          ? responseData
          : <String, dynamic>{'records': []},
    );
  } on DioException catch (e) {
    print("Attendance API Error: ${e.response?.data}");
    rethrow;
  }
}

  Future<AttendanceResponse> getEmpFullAttendence({required String eid}) async {
    final response = await ApiClient.dio.get('/api/attendance/company/$eid');

    return AttendanceResponse.fromJson(response.data);
  }
}
