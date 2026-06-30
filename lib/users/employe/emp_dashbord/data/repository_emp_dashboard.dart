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
  required String? checkoutReason,
}) async {

  FormData formData = FormData.fromMap({
    "latitude": latitude,
    "longitude": longitude,
    "checkoutReason": checkoutReason,
    "livePhoto": await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    ),
  });
   print("this is from the checkOut");

  final res = await ApiClient.dio.post(
    "/api/attendance/check-out",
    data: formData,
  );
  print("this is the res from the checkOut ${res.data}");

  return res.data;
}
Future<Map<String, dynamic>> submitWork({
  required String workType,
  required String description,
}) async {
   print("this is the title ${workType}");
      print("this is the description ${description}");
  final response = await ApiClient.dio.post(
    "/api/attendance/daily-work",
    data: {
      "title": workType,
      "dailyWorkSummary": description,
    },
  );

  return Map<String, dynamic>.from(response.data);
}

}