import 'package:dio/dio.dart';
import '../../core/services/api_client.dart';

class InviteEmpRepo {
  

  /// GET departments
  Future<Response> getDepartments(String companyId) async {
    return await ApiClient.dio.get(
      "api/master/company-departments",
      queryParameters: {"companyId": companyId},
    );
  }

  /// GET designations
  Future<Response> getDesignations(String departmentId) async {
    return await ApiClient.dio.get(
      "api/master/designations",
      queryParameters: {"departmentId": departmentId},
    );
  }

  /// CREATE employee
  Future<Response> createEmployee(Map<String, dynamic> body) async {
    return await ApiClient.dio.post(
      "api/invite/invite",
      data: body,
    );
  }
}