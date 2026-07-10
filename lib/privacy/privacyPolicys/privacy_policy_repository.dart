import 'package:dio/dio.dart';

import '../../core/services/api_client.dart';
import 'data/privacy_policy_model.dart';


class PrivacyPolicyRepository {
  Future<PrivacyPolicyModel> getPrivacyPolicy(String?data) async {
  final endpoint=data!="Terms"? "/api/master/policies/privacy-policy": "/api/master/policies/terms-and-conditions";
    final response = await ApiClient.dio.get(
     endpoint,
    );

    return PrivacyPolicyModel.fromJson(
      response.data["data"],
    );
  }
}