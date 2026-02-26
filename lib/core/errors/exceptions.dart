// ─────────────────────────────────────────────
//  exceptions.dart  –  Memomate
//  All custom exceptions thrown in the data layer
// ─────────────────────────────────────────────

// ── Network / HTTP ────────────────────────────

/// Thrown when there is no internet connection.
class NoInternetException implements Exception {
  final String message;
  const NoInternetException({this.message = 'No internet connection.'});
}

/// Thrown when the server returns a non-2xx status code.
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException({required this.message, this.statusCode});
}

/// Thrown when the request times out.
class RequestTimeoutException implements Exception {
  final String message;
  const RequestTimeoutException({this.message = 'Request timed out.'});
}

/// Thrown when the response body cannot be parsed.
class ParseException implements Exception {
  final String message;
  const ParseException({this.message = 'Failed to parse server response.'});
}

// ── Auth ──────────────────────────────────────

/// Thrown when the user provides wrong credentials.
class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException({
    this.message = 'Invalid email or password.',
  });
}

/// Thrown when the auth token is missing or expired.
class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException({
    this.message = 'Session expired. Please log in again.',
  });
}

/// Thrown when a sign-up email is already registered.
class EmailAlreadyInUseException implements Exception {
  final String message;
  const EmailAlreadyInUseException({
    this.message = 'This email is already registered.',
  });
}

/// Thrown when the user's account is suspended or not verified.
class AccountException implements Exception {
  final String message;
  const AccountException({required this.message});
}

// ── Cache / Local Storage ─────────────────────

/// Thrown when a local cache read/write fails.
class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Local cache error.'});
}

// ── Doctor ────────────────────────────────────

/// Thrown when a doctor profile is not found.
class DoctorNotFoundException implements Exception {
  final String message;
  const DoctorNotFoundException({this.message = 'Doctor not found.'});
}

// ── Memory Games ──────────────────────────────

/// Thrown when a game session cannot be started or found.
class GameSessionException implements Exception {
  final String message;
  const GameSessionException({required this.message});
}

// ── Reminders ─────────────────────────────────

/// Thrown when creating / updating a reminder fails.
class ReminderException implements Exception {
  final String message;
  const ReminderException({required this.message});
}

// ── Reports ───────────────────────────────────

/// Thrown when fetching or generating a report fails.
class ReportException implements Exception {
  final String message;
  const ReportException({required this.message});
}

// ── Profile ───────────────────────────────────

/// Thrown when updating the user profile fails.
class ProfileException implements Exception {
  final String message;
  const ProfileException({required this.message});
}

// ── Generic ───────────────────────────────────

/// Fallback for any unexpected exception.
class UnexpectedException implements Exception {
  final String message;
  const UnexpectedException({this.message = 'An unexpected error occurred.'});
}
