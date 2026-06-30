import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/services/api_client.dart';

class EmpProfileRepository {
  EmpProfileRepository({
    Dio? dio,
    this.baseUrl = '/api/employee/self',
  }) : _dio = dio ?? ApiClient.dio;

  final Dio _dio;
  final String baseUrl;

  Future<Map<String, dynamic>> fetchBasic(String employeeId) async {
    final response = await _dio.get('$baseUrl/$employeeId/basic');
    return _unwrapMap(response.data);
  }

  Future<Map<String, dynamic>> fetchPersonal(String employeeId) async {
    final response = await _dio.get('$baseUrl/$employeeId/personal');
    return _unwrapMap(response.data);
  }

  Future<Map<String, dynamic>> fetchProfessional(String employeeId) async {
    try {
      final response = await _dio.get('$baseUrl/$employeeId/professional');
      return _unwrapMap(response.data);
    } on DioException catch (error) {
      final status = error.response?.statusCode ?? 0;
      if (status != 404) rethrow;

      final response = await _dio.get('$baseUrl/$employeeId/professiona');
      return _unwrapMap(response.data);
    }
  }

  Future<Map<String, dynamic>> fetchFinancial(String employeeId) async {
    final response = await _dio.get('$baseUrl/$employeeId/financial');
    return _unwrapMap(response.data);
  }

  Future<List<Map<String, dynamic>>> fetchDocuments(String employeeId) async {
    final response = await _dio.get('$baseUrl/$employeeId/documents');
    return _deduplicateDocuments(_unwrapList(response.data));
  }

  Future<Map<String, dynamic>> updateBasic({
    required String employeeId,
    required Map<String, dynamic> values,
    File? profilePhoto,
  }) async {
    final body = FormData.fromMap({
      ...values,
      if (profilePhoto != null)
        'profilePhoto': await MultipartFile.fromFile(
          profilePhoto.path,
          filename: profilePhoto.path.split(Platform.pathSeparator).last,
        ),
    });

    final response = await _dio.patch(
      '$baseUrl/$employeeId/basic',
      data: body,
      options: Options(contentType: 'multipart/form-data'),
    );
    return _unwrapMap(response.data);
  }

  Future<Map<String, dynamic>> updatePersonal(
    String employeeId,
    Map<String, dynamic> values,
  ) async {
    final response = await _dio.patch(
      '$baseUrl/$employeeId/personal',
      data: values,
    );
    return _unwrapMap(response.data);
  }

  Future<Map<String, dynamic>> updateProfessional(
    String employeeId,
    Map<String, dynamic> values,
  ) async {
    try {
      final response = await _dio.patch(
        '$baseUrl/$employeeId/professional',
        data: values,
      );
      return _unwrapMap(response.data);
    } on DioException catch (error) {
      final status = error.response?.statusCode ?? 0;
      if (status != 404) rethrow;

      final response = await _dio.patch(
        '$baseUrl/$employeeId/professiona',
        data: values,
      );
      return _unwrapMap(response.data);
    }
  }

  Future<Map<String, dynamic>> updateFinancial(
    String employeeId,
    Map<String, dynamic> values,
  ) async {
    final response = await _dio.patch(
      '$baseUrl/$employeeId/financial',
      data: values,
    );
    return _unwrapMap(response.data);
  }

  Future<List<Map<String, dynamic>>> uploadDocument({
    required String employeeId,
    required String documentType,
    required File file,
  }) async {
    final body = FormData.fromMap({
      'documentType': documentType,
      'type': documentType,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    try {
      final response = await _dio.post(
        '$baseUrl/$employeeId/documents',
        data: body,
        options: Options(contentType: 'multipart/form-data'),
      );
      return _deduplicateDocuments(_unwrapList(response.data));
    } on DioException catch (error) {
      final status = error.response?.statusCode ?? 0;
      if (status != 404 && status != 405) rethrow;

      final response = await _dio.patch(
        '$baseUrl/$employeeId/documents',
        data: body,
        options: Options(contentType: 'multipart/form-data'),
      );
      return _deduplicateDocuments(_unwrapList(response.data));
    }
  }

  Map<String, dynamic> _unwrapMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      final data = value['data'];
      if (data is Map<String, dynamic>) return data;
      if (data is List) return {'items': data};
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return {};
  }

  List<Map<String, dynamic>> _unwrapList(dynamic value) {
    final data = value is Map ? value['data'] ?? value['documents'] : value;

    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    if (data is Map) {
      final possibleList =
          data['documents'] ?? data['items'] ?? data['files'] ?? data['data'];
      if (possibleList is List) {
        return possibleList
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
      return [Map<String, dynamic>.from(data)];
    }

    return [];
  }

  List<Map<String, dynamic>> _deduplicateDocuments(
    List<Map<String, dynamic>> documents,
  ) {
    final seen = <String>{};
    final deduped = <Map<String, dynamic>>[];

    for (final document in documents) {
      final key =
          [
                document['id'],
                document['_id'],
                document['documentType'],
                document['type'],
                document['name'],
                document['fileName'],
                document['url'],
                document['fileUrl'],
              ]
              .where(
                (value) => value != null && value.toString().trim().isNotEmpty,
              )
              .join('|');

      final fallbackKey = document.entries
          .map((entry) => '${entry.key}:${entry.value}')
          .join('|');
      final dedupeKey = key.isEmpty ? fallbackKey : key;

      if (seen.add(dedupeKey)) {
        deduped.add(document);
      }
    }

    return deduped;
  }
}

