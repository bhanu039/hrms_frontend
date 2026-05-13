import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../company/models/company_model.dart';
import '../company/models/employee_model.dart';
import '../company/models/plan_model.dart';
import '../state/models/Employee_data_Model.dart';
import 'api_client.dart';
import 'dart:io';

class ApiService {
  // 🔥 OPTIONAL: Wake up server (Render fix)
  static Future<void> wakeUpServer() async {
    try {
      final response = await ApiClient.dio.get("/");
      print("Server awake: ${response.statusCode}");
    } catch (e) {
      print("Wake up error: $e");
    }
  }

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

  // 🔵 GET ALL PLANS
  static Future<List<Plan>> getSubscriptionPlans() async {
    final response = await ApiClient.dio.get("subscription/plans");
    print("getSubscriptionPlans response: ${response.data}");

    if (response.statusCode == 200 && response.data["success"] == true) {
      final data = response.data["data"] ?? [];
      print("getSubscriptionPlans data: $data");

      return (data as List).map((e) => Plan.fromJson(e)).toList();
    }

    throw Exception("Failed to load plans");
  }

  // 🟢 CREATE PLAN
  static Future<Response> createSubscriptionPlan({
    required String title,
    required int price,
    required int duration,
    required List<String> features,
  }) async {
    print(
      "Creating plan with title: $title, price: $price, duration: $duration, features: $features",
    );
    return await ApiClient.dio.post(
      "subscription/plans",
      data: {
        "title": title,
        "price": price,
        "duration": duration,
        "features": features,
      },
    );
  }

  // 🟡 UPDATE PLAN
  static Future<Response> updateSubscriptionPlan({
    required String id,
    required String title,
    required int price,
    required int duration,
    required List<String> features,
  }) async {
    return await ApiClient.dio.put(
      "subscription/plans/$id",
      data: {
        "title": title,
        "price": price,
        "duration": duration,
        "features": features,
      },
    );
  }

  // 🔴 DELETE PLAN
  static Future<Response> deleteSubscriptionPlan(String id) async {
    return await ApiClient.dio.delete("subscription/plans/$id");
  }

  static Future<bool> deleteCompany(String id) async {
    try {
      final response = await ApiClient.dio.delete("company/$id");
      return response.statusCode == 200 && response.data["success"] == true;
    } catch (e) {
      return false;
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

  /// GET COMPANY PROFILE
  static Future<CompanyModel?> getCompanyProfile() async {
    try {
      final response = await ApiClient.dio.get("company/profile");

      print(response.data);

      if (response.statusCode == 200) {
        return CompanyModel.fromJson(response.data["data"]);
      }
    } catch (e) {
      debugPrint("GET ERROR => $e");
    }

    return null;
  }

  static Future<List<EmployeeModel>> getEmployees() async {
    final response = await ApiClient.dio.get("employee");

    print("EMPLOYEE RESPONSE => ${response.data}");

    if (response.statusCode == 200 && response.data["success"] == true) {
      final List data = response.data["data"];

      return data.map((e) => EmployeeModel.fromJson(e)).toList();
    }

    throw Exception("Failed to load employees");
  }

  Future<void> createEmployee(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post("/employees", data: data);
      print(response.data);
    } catch (e) {
      print("ERROR: $e");
      rethrow;
    }
  }

  static Future<EmployeeDataModel> getEmployee(String employee) async {
    final response = await ApiClient.dio.get("onboarding/review/$employee");

    print("EMPLOYEE RESPONSE => ${response.data}");

    if (response.statusCode == 200 && response.data["success"] == true) {
      final data = response.data ["data"];

     
      return  EmployeeDataModel.fromJson(data);
    }
    throw Exception("Failed to load employee data");
  }

  
   Future<Response> updateCompany({
    required Map<String, dynamic> data,
    String? companyLogoPath,
    String? gstFilePath,
  }) async {
    FormData formData = FormData.fromMap({
      ...data,

      if (companyLogoPath != null)
        "companyLogo": await MultipartFile.fromFile(
          companyLogoPath,
          filename: companyLogoPath.split('/').last,
        ),

      if (gstFilePath != null)
        "gstFile": await MultipartFile.fromFile(
          gstFilePath,
          filename: gstFilePath.split('/').last,
        ),
    });

    // using existing api client
    return await ApiClient.dio.put(
      "/company/update",
      data: formData,
    );
  }

}
