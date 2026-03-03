// ─────────────────────────────────────────────
//  user_repository_impl.dart  –  Memomate
// ─────────────────────────────────────────────

import 'package:gradproj/core/errors/exceptions.dart';
import 'package:gradproj/core/errors/failures.dart';
import 'package:gradproj/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:gradproj/features/user/data/models/user_models.dart';
import 'package:gradproj/features/user/data/models/user_register_model.dart';

abstract class UserRepository {
  Future<Failure?> registerUser(UserRegisterModel model);
  Future<({UserProfile? profile, String? token, Failure? failure})> loginUser(
    UserLoginModel model,
  );
  Future<({UserProfile? profile, Failure? failure})> updateUserProfile(
    Map<String, dynamic> data,
    String token,
  );
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;
  UserRepositoryImpl(this._remote);

  @override
  Future<Failure?> registerUser(UserRegisterModel model) async {
    try {
      await _remote.registerUser(model);
      return null;
    } on NoInternetException {
      return const NoInternetFailure();
    } on RequestTimeoutException {
      return const RequestTimeoutFailure();
    } on ServerException catch (e) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } catch (e) {
      return UnexpectedFailure(message: e.toString());
    }
  }

  @override
  Future<({UserProfile? profile, String? token, Failure? failure})> loginUser(
    UserLoginModel model,
  ) async {
    try {
      final response = await _remote.loginUser(model);
      return (profile: response.profile, token: response.token, failure: null);
    } on NoInternetException {
      return (profile: null, token: null, failure: const NoInternetFailure());
    } on RequestTimeoutException {
      return (
        profile: null,
        token: null,
        failure: const RequestTimeoutFailure(),
      );
    } on ServerException catch (e) {
      return (
        profile: null,
        token: null,
        failure: ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return (
        profile: null,
        token: null,
        failure: UnexpectedFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<({UserProfile? profile, Failure? failure})> updateUserProfile(
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      final updatedProfile = await _remote.updateUserProfile(data, token);
      return (profile: updatedProfile, failure: null);
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
