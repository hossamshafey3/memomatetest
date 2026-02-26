// ─────────────────────────────────────────────
//  doctor_repository_impl.dart  –  Memomate
//  Repository that bridges data source ↔ cubit,
//  mapping exceptions to Failures.
// ─────────────────────────────────────────────

import 'package:gradproj/core/errors/exceptions.dart';
import 'package:gradproj/core/errors/failures.dart';
import 'package:gradproj/features/doctor/data/data_sources/doctor_remote_data_source.dart';
import 'package:gradproj/features/doctor/data/models/doctor_model.dart';

abstract class DoctorRepository {
  Future<({DoctorProfile? profile, Failure? failure})> registerDoctor(
    DoctorRegisterModel model,
  );
  Future<({DoctorProfile? profile, Failure? failure})> loginDoctor(
    DoctorLoginModel model,
  );
  Future<({DoctorProfile? profile, Failure? failure})> updateDoctor(
    String id,
    Map<String, dynamic> fields,
  );
}

class DoctorRepositoryImpl implements DoctorRepository {
  final DoctorRemoteDataSource _remoteDataSource;

  DoctorRepositoryImpl(this._remoteDataSource);

  @override
  Future<({DoctorProfile? profile, Failure? failure})> registerDoctor(
    DoctorRegisterModel model,
  ) async {
    try {
      final profile = await _remoteDataSource.registerDoctor(model);
      return (profile: profile, failure: null);
    } on NoInternetException {
      return (profile: null, failure: const NoInternetFailure());
    } on RequestTimeoutException {
      return (profile: null, failure: const RequestTimeoutFailure());
    } on ServerException catch (e) {
      return (
        profile: null,
        failure: ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return (profile: null, failure: UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<({DoctorProfile? profile, Failure? failure})> loginDoctor(
    DoctorLoginModel model,
  ) async {
    try {
      final profile = await _remoteDataSource.loginDoctor(model);
      return (profile: profile, failure: null);
    } on NoInternetException {
      return (profile: null, failure: const NoInternetFailure());
    } on RequestTimeoutException {
      return (profile: null, failure: const RequestTimeoutFailure());
    } on ServerException catch (e) {
      return (
        profile: null,
        failure: ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return (profile: null, failure: UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<({DoctorProfile? profile, Failure? failure})> updateDoctor(
    String id,
    Map<String, dynamic> fields,
  ) async {
    try {
      final profile = await _remoteDataSource.updateDoctor(id, fields);
      return (profile: profile, failure: null);
    } on NoInternetException {
      return (profile: null, failure: const NoInternetFailure());
    } on RequestTimeoutException {
      return (profile: null, failure: const RequestTimeoutFailure());
    } on ServerException catch (e) {
      return (
        profile: null,
        failure: ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return (profile: null, failure: UnexpectedFailure(message: e.toString()));
    }
  }
}
