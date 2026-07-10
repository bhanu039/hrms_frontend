import '../core/services/api_client.dart';

class CompanyListRepo {
   static Future<Map<String, dynamic>> getCompanies(String? status) async {
    try {
      final endpoint = status == 'deleted'? "api/company/soft-deleted" : "api/company";
      final response = await ApiClient.dio.get(endpoint);
      print("response: ${response.data}");
      if (response.statusCode == 200 && response.data["success"] == true) {
        return {"companies": response.data["data"] ?? []};
      } else {
        throw Exception("Failed to load companies");
      }
    } catch (e) {
      throw Exception("Error fetching companies: $e");
    }
  }
 

  static Future<bool> deleteCompany(String status, String id) async {
    try {
      final endpoint = status == 'deleted' ? "api/company/$id?type=hard" : "api/company/$id";
      final response = await ApiClient.dio.delete(endpoint);
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> restoreCompany(String? id) async {
    final response = await ApiClient.dio.post("api/company/restore/$id");
    print("CREATE restore  RESPONSE => ${response.data}");
    return response.data["success"];
  }
  
}