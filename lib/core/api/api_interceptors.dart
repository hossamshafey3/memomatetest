// ─────────────────────────────────────────────
//  api_interceptors.dart  –  Memomate
//  Dio interceptor that:
//    1. Attaches the Bearer token to every request.
//    2. Logs requests & responses in debug mode.
//    3. Maps Dio errors → app-level ServerException.
// ─────────────────────────────────────────────

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gradproj/core/errors/exceptions.dart';

class ApiInterceptors extends Interceptor {
  // ── Token storage key (shared_preferences / secure_storage) ──
  // Replace the placeholder below with your actual token retrieval logic.
  static String? _cachedToken;

  static void setToken(String token) => _cachedToken = token;
  static void clearToken() => _cachedToken = null;
  static String? getToken() => _cachedToken;

  // ── Request ──────────────────────────────────────────────────

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _cachedToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';

    if (kDebugMode) {
      debugPrint('──────────────────────────────────');
      debugPrint('→ [REQUEST]  ${options.method} ${options.uri}');
      if (options.data != null) debugPrint('   Body : ${options.data}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('   Query: ${options.queryParameters}');
      }
    }

    super.onRequest(options, handler);
  }

  // ── Response ─────────────────────────────────────────────────

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '← [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
      );
      debugPrint('   Data : ${response.data}');
      debugPrint('──────────────────────────────────');
    }
    super.onResponse(response, handler);
  }

  // ── Error ────────────────────────────────────────────────────

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '✖ [ERROR] ${err.type} | ${err.response?.statusCode} | ${err.message}',
      );
    }

    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        throw const NoInternetException();

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const RequestTimeoutException();

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final message =
            _extractMessage(err.response?.data) ?? 'Server error ($statusCode)';

        if (statusCode == 401) throw UnauthorizedException(message: message);
        if (statusCode == 403) throw AccountException(message: message);

        throw ServerException(message: message, statusCode: statusCode);

      default:
        throw ServerException(
          message: err.message ?? 'An unexpected server error occurred.',
        );
    }
  }

  // ── Helpers ──────────────────────────────────────────────────

  /// Tries to extract a readable message from the API error body.
  String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return (data['message'] ?? data['error'] ?? data['detail'])?.toString();
    }
    return data.toString();
  }
}
