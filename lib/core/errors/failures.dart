// ─────────────────────────────────────────────
//  failures.dart  –  Memomate
//  All Failure classes used in the domain layer (Clean Architecture)
//  Each Failure maps to one or more Exceptions from exceptions.dart
// ─────────────────────────────────────────────

import 'package:equatable/equatable.dart';

/// Base class for all failures.
abstract class Failure extends Equatable {
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

// ── Network / HTTP ────────────────────────────

/// No internet connection.
class NoInternetFailure extends Failure {
  const NoInternetFailure({super.message = 'No internet connection.'});
}

/// Server returned an error (4xx / 5xx).
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({required super.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Request timed out.
class RequestTimeoutFailure extends Failure {
  const RequestTimeoutFailure({super.message = 'Request timed out.'});
}

/// Could not parse the server response.
class ParseFailure extends Failure {
  const ParseFailure({super.message = 'Failed to parse server response.'});
}

// ── Auth ──────────────────────────────────────

/// Wrong email or password.
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password.',
  });
}

/// Token missing or expired – user must log in again.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired. Please log in again.',
  });
}

/// Email is already registered.
class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure({
    super.message = 'This email is already registered.',
  });
}

/// Account suspended / not verified / other account-level issue.
class AccountFailure extends Failure {
  const AccountFailure({required super.message});
}

// ── Cache / Local Storage ─────────────────────

/// Local cache read/write failed.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local cache error.'});
}

// ── Doctor ────────────────────────────────────

/// Doctor profile not found.
class DoctorNotFoundFailure extends Failure {
  const DoctorNotFoundFailure({super.message = 'Doctor not found.'});
}

// ── Memory Games ──────────────────────────────

/// Game session could not be started or found.
class GameSessionFailure extends Failure {
  const GameSessionFailure({required super.message});
}

// ── Reminders ─────────────────────────────────

/// Reminder create / update failed.
class ReminderFailure extends Failure {
  const ReminderFailure({required super.message});
}

// ── Reports ───────────────────────────────────

/// Report fetch / generation failed.
class ReportFailure extends Failure {
  const ReportFailure({required super.message});
}

// ── Profile ───────────────────────────────────

/// Profile update failed.
class ProfileFailure extends Failure {
  const ProfileFailure({required super.message});
}

// ── Generic ───────────────────────────────────

/// Fallback for any unexpected error.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'An unexpected error occurred.'});
}
