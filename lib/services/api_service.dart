import 'dart:convert';

import 'package:dio/dio.dart';
import '../company/models/employee_model.dart';
import 'api_client.dart';
import 'dart:io';

class ApiService {
  // 🔐 LOGIN
  static Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await ApiClient.dio.post(
      "auth/login",
      data: {"email": email, "password": password},
      options: Options(validateStatus: (status) => true),
    );
  }

  // 🏢 CREATE COMPANY
  static Future<Response> createCompany({
    required String name,
    required String email,
    required String location,
    required String ownerName,
    required String ownerEmail,
  }) async {
    return await ApiClient.dio.post(
      "company/create",
      data: {
        "name": name,
        "email": email,
        "location": location,
        "ownerName": ownerName,
        "ownerEmail": ownerEmail,
      },
      options: Options(validateStatus: (status) => true),
    );
  }

  static Future<Map<String, dynamic>> getCompanies() async {
    try {
      final response = await ApiClient.dio.get("company");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return {
          "companies": response.data["data"] ?? [],

          "count": response.data["count"] ?? 0,
        };
      } else {
        throw Exception("Failed to load companies");
      }
    } catch (e) {
      throw Exception("Error fetching companies: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getSubscriptionPlans() async {
    final response = await ApiClient.dio.get("subscription/plans");

    if (response.statusCode == 200 && response.data["success"] == true) {
      final data = response.data["data"] ?? [];
      return List<Map<String, dynamic>>.from(
        (data as List).map((item) => Map<String, dynamic>.from(item as Map)),
      );
    }

    throw Exception("Failed to load subscription plans");
  }

  static Future<Response> createSubscriptionPlan({
    required String name,
    required double price,
    required int duration,
    required String support,
    required String employees,
  }) async {
    return await ApiClient.dio.post(
      "subscription/plans",
      data: {
        "name": name,
        "price": price,
        "duration": duration,
        "features": {"support": support, "employees": employees},
      },
      options: Options(validateStatus: (status) => true),
    );
  }

  static Future<Response> updateSubscriptionPlan({
    required String id,
    required String name,
    required double price,
    required int duration,
    required String support,
    required String employees,
  }) async {
    return await ApiClient.dio.put(
      "subscription/plans/$id",
      data: {
        "name": name,
        "price": price,
        "duration": duration,
        "features": {"support": support, "employees": employees},
      },
      options: Options(validateStatus: (status) => true),
    );
  }

  static Future<Response> deleteSubscriptionPlan(String id) async {
    return await ApiClient.dio.delete(
      "subscription/plans/$id",
      options: Options(validateStatus: (status) => true),
    );
  }

  static Future<bool> deleteCompany(String id) async {
    try {
      final response = await ApiClient.dio.delete("company/$id");
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      return false;
    }
  }

 static Future<void> setPassword({
  required String token,
  required String password,
}) async {
  try {
    final response = await ApiClient.dio.post(
      "/set-password",
      data: {
        "token": token,
        "password": password,
      },
    );

    print("SUCCESS: ${response.data}");
  } catch (e) {
    if (e is DioException) {
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
    }
    print("ERROR: $e");
    rethrow;
  }
}

  static Future updateProfile({
    required String name,
    required String email,
    File? image,
  }) async {
    String? base64Image;

    if (image != null) {
      final bytes = await image.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    final response = await ApiClient.dio.post(
      "auth/update-profile",
      data: {"name": name, "email": email, "profileLogo": base64Image},
    );

    return response.data;
  }

  static Future<Map<String, dynamic>> changePassword(
    String id,
    String oldPass,
    String newPass,
  ) async {
    try {
      print(
        "Changing password for user ID: ========================================================>>>>>>> $id",
      );
      final res = await ApiClient.dio.post(
        "auth/change-password",
        data: {"oldPassword": oldPass, "newPassword": newPass},
      );
      print("change-password API response: ${res.data}");

      return res.data;
    } catch (e) {
      return {"success": false, "message": "Something went wrong"};
    }
  }

  static Future<Response> activateCompany(String id) async {
    final data = {"id": id, "companyId": id};

    final response = await ApiClient.dio.post(
      "company/activate",
      data: data,
      options: Options(validateStatus: (status) => true),
    );
     print(response.data);

    if (response.statusCode == 404 ||
        (response.data is Map<String, dynamic> &&
            response.data['message']?.toString().toLowerCase().contains(
                  'not found',
                ) ==
                true)) {
      return await ApiClient.dio.post(
        "company/activate/$id",
        data: data,
        options: Options(validateStatus: (status) => true),
      );
    }

    return response;
  }



  Future<List<Employee>> getEmployees() async {
    try {
      final response = await ApiClient.dio.get("/employees");

      final List data = response.data;
       print(response.data);

      return data.map((json) => Employee.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Failed to fetch employees");
    }
  }

 Future<void> createEmployee(Map<String, dynamic> data) async {
  try {
    final response = await ApiClient.dio.post(
      "/employees",
      data: data,
    );
    print(response.data);
  } catch (e) {
    print("ERROR: $e");
    rethrow;
  }
}

  // 🔥 OPTIONAL: Wake up server (Render fix)
  static Future<void> wakeUpServer() async {
    try {
      final response = await ApiClient.dio.get("/");
      print("Server awake: ${response.statusCode}");
    } catch (e) {
      print("Wake up error: $e");
    }
  }
}
