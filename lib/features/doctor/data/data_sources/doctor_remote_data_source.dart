// ─────────────────────────────────────────────
//  doctor_remote_data_source.dart  –  Memomate
//  Remote data source for Doctor feature.
// ─────────────────────────────────────────────

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gradproj/core/api/endpoints.dart';
import 'package:gradproj/core/errors/exceptions.dart';
import 'package:gradproj/features/doctor/data/models/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  /// POSTs a new doctor registration to the API.
  Future<DoctorProfile> registerDoctor(DoctorRegisterModel model);

  /// POSTs doctor login credentials and returns the login response (token + profile).
  Future<DoctorLoginResponse> loginDoctor(DoctorLoginModel model);

  /// PUTs updated doctor fields — requires the JWT token for Authorization.
  Future<DoctorProfile> updateDoctor(String token, Map<String, dynamic> fields);
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final Dio _dio;

  DoctorRemoteDataSourceImpl(this._dio);

  // Safely convert response body to Map regardless of whether
  // Dio parsed the JSON or left it as a raw String.
  Map<String, dynamic> _parseBody(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    // Handle Map<dynamic, dynamic> (sometimes produced by Dio/jsonDecode)
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          return decoded.map((k, v) => MapEntry(k.toString(), v));
        }
      } catch (_) {}
    }
    return {};
  }

  @override
  Future<DoctorProfile> registerDoctor(DoctorRegisterModel model) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.doctorRegister}',
        data: model.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          // Don't throw on non-2xx so we can read the body ourselves
          validateStatus: (status) => true,
        ),
      );

      final body = _parseBody(response.data);
      final success = body['success'] as bool? ?? false;

      if (success) {
        return DoctorProfile.fromJson(_parseBody(body['data']));
      } else {
        final message =
            body['message'] as String? ?? 'Registration failed. Try again.';
        throw ServerException(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const RequestTimeoutException();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const NoInternetException();
      }
      final body = _parseBody(e.response?.data);
      final message =
          body['message'] as String? ?? 'An unexpected error occurred.';
      throw ServerException(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<DoctorLoginResponse> loginDoctor(DoctorLoginModel model) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.doctorLogin}',
        data: model.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => true,
        ),
      );

      final body = _parseBody(response.data);
      final success = body['success'] as bool? ?? false;

      if (success) {
        return DoctorLoginResponse.fromJson(body);
      } else {
        final message =
            body['message'] as String? ?? 'Login failed. Try again.';
        throw ServerException(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const RequestTimeoutException();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const NoInternetException();
      }
      final body = _parseBody(e.response?.data);
      final message =
          body['message'] as String? ?? 'An unexpected error occurred.';
      throw ServerException(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<DoctorProfile> updateDoctor(
    String token,
    Map<String, dynamic> fields,
  ) async {
    try {
      final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.doctorUpdate}';

      final response = await _dio.put(
        url,
        data: jsonEncode(fields),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => true,
        ),
      );

      // ignore: avoid_print
      print(
        '[updateDoctor] status=${response.statusCode} body=${response.data}',
      );

      final body = _parseBody(response.data);
      final rawSuccess = body['success'];
      final success =
          rawSuccess == true || rawSuccess.toString().toLowerCase() == 'true';

      if (success) {
        return DoctorProfile.fromJson(_parseBody(body['data']));
      } else {
        final message =
            body['message'] as String? ??
            body['error'] as String? ??
            'Update failed (status ${response.statusCode}).';
        throw ServerException(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const RequestTimeoutException();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const NoInternetException();
      }
      final body = _parseBody(e.response?.data);
      final message =
          body['message'] as String? ?? 'An unexpected error occurred.';
      throw ServerException(
        message: message,
        statusCode: e.response?.statusCode,
      );
    }
  }
}
