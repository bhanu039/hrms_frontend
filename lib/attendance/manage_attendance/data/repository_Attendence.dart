

import 'package:goexperts/core/services/api_client.dart';

import 'attendance_model.dart';

class AttendenceRepository {
  Future<AttendanceResponse> getEmployeesAttendence({
  required int currentPage,
  String? search,
  String? status,
  String? fromDate,
  String? toDate,
}) async {
  final response = await ApiClient.dio.get(
    '/api/attendance/company',
    queryParameters: {
      'currentPage': currentPage,
      'page_size': 20,
      if (search?.isNotEmpty ?? false) 'search': search,
      if (status?.isNotEmpty ?? false) 'status': status,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
    },
  );

  return AttendanceResponse.fromJson(response.data);;
}
Future<AttendanceResponse> getEmpFullAttendence({
  required String eid,
 
}) async {
  final response = await ApiClient.dio.get(
    '/api/attendance/company/$eid',
   
  );

  return AttendanceResponse.fromJson(response.data);
}
}



