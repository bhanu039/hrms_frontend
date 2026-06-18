import 'package:goexperts/core/services/api_client.dart';

import 'attendance_model.dart';

class SelfAttendanceRepository {
  Future<SelfAttendanceResponse> getMyAttendance({
    String date = '',
    String fromDate = '',
    String toDate = '',
    String month = '',
    String year = '',
    String status = '',
    String sort = 'desc',
  }) async {
    final response = await ApiClient.dio.get(
      '/api/attendance/me',
      queryParameters: {
        if (date.isNotEmpty) 'date': date,
        if (fromDate.isNotEmpty) 'fromDate': fromDate,
        if (toDate.isNotEmpty) 'toDate': toDate,
        if (month.isNotEmpty) 'month': month,
        if (year.isNotEmpty) 'year': year,
        if (status.isNotEmpty) 'status': status,
        if (sort.isNotEmpty) 'sort': sort,
      },
    );

    final responseData = response.data is Map<String, dynamic>
        ? response.data['data'] ?? response.data
        : response.data;

    return SelfAttendanceResponse.fromJson(
      responseData as Map<String, dynamic>,
    );
  }
}
