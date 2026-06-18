import 'package:dio/dio.dart';
import 'package:goexperts/core/services/api_client.dart';

class CompanyDashboardRepository {
  
  Future<Response> getDashboard(
  
  ) async {
    return await ApiClient.dio.get(
      "/api/company/dashboard",
     
    );
  }
}