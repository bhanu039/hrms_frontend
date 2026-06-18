import 'dart:io';

import 'package:dio/dio.dart';
import 'package:goexperts/core/services/api_client.dart';

class HrDashboardRepository {
  
  Future<Response> getDashboard(
  
  ) async {
    return await ApiClient.dio.get(
      "/api/company/dashboard",
     
    );
  }
    Future<Map<String, dynamic>> checkinData(
    File livePhotoFile,
    double latitude,
    double longitude,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        "livePhoto": await MultipartFile.fromFile(
          livePhotoFile.path,
          filename: "face.jpg",
        ),

        "latitude": latitude,
        "longitude": longitude,
      });

      Response response = await ApiClient.dio.post(
        "api/attendance/clock-in",
        data: formData,
        options: Options(validateStatus: (status) => true),
      );

      return response.data;
    } catch (e) {
      print("this is the catch block");
      return {"success": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> checkoutData(
    File livePhotoFile,
    double latitude,
    double longitude,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        "api/livePhoto": await MultipartFile.fromFile(
          livePhotoFile.path,
          filename: "face.jpg",
        ),

        "latitude": latitude,
        "longitude": longitude,
      });

      Response response = await ApiClient.dio.post(
        "api/attendance/clock-out",
        data: formData,
        options: Options(validateStatus: (status) => true),
      );

      return response.data;
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }
}