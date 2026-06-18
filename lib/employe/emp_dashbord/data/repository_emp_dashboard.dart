import 'package:dio/dio.dart';
import 'package:goexperts/core/services/api_client.dart';

class RepositoryEmpDashboard {
 

  Future<Map<String, dynamic>> getDashboard() async {
    final res = await ApiClient.dio.get("/api/company/dashboard");
    return res.data;
  }

  Future<Map<String, dynamic>> checkIn() async {
    final res = await ApiClient.dio.post("/api/attendance/check-in");
    return res.data;
  }

  Future<Map<String, dynamic>> checkOut() async {
    final res = await ApiClient.dio.post("/api/attendance/check-out");
    return res.data;
  }
}