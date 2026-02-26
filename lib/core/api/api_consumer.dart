// ─────────────────────────────────────────────
//  api_consumer.dart  –  Memomate
//  Abstract contract for all HTTP operations.
//  Concrete implementation uses Dio (see DioConsumer).
// ─────────────────────────────────────────────

abstract class ApiConsumer {
  /// Sends a GET request to [path].
  /// [queryParameters] – optional query string params.
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});

  /// Sends a POST request to [path] with [body] as JSON.
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool isFormData = false,
  });

  /// Sends a PUT request to [path] with [body] as JSON.
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    bool isFormData = false,
  });

  /// Sends a PATCH request to [path] with [body] as JSON.
  Future<dynamic> patch(String path, {Map<String, dynamic>? body});

  /// Sends a DELETE request to [path].
  Future<dynamic> delete(String path, {Map<String, dynamic>? queryParameters});
}
