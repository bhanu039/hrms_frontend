import 'dart:io';

import 'package:dio/dio.dart';
import 'package:goexperts/core/services/api_client.dart';

class RepositoryEmpDashboard {
 

  Future<Map<String, dynamic>> getDashboard() async {
    final res = await ApiClient.dio.get("/api/company/dashboard");
    return res.data;
  }

Future<Map<String, dynamic>> checkIn({
  required File file,
  required double longitude,
  required double latitude,
  required String mode,
}) async {

  FormData formData = FormData.fromMap({
    "latitude": latitude,
    "longitude": longitude,
    "requestedWorkType": mode,
    "livePhoto": await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    ),
  });

  final res = await ApiClient.dio.post(
    "/api/attendance/check-in",
    data: formData,
  );

  return res.data;
}

 Future<Map<String, dynamic>> checkOut({
  required File file,
  required double latitude,
  required double longitude,
}) async {

  FormData formData = FormData.fromMap({
    "latitude": latitude,
    "longitude": longitude,
    "livePhoto": await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    ),
  });

  final res = await ApiClient.dio.post(
    "/api/attendance/check-out",
    data: formData,
  );

  return res.data;
}

}