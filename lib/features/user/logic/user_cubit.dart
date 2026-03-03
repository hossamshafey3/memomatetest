// ─────────────────────────────────────────────
//  user_cubit.dart  –  Memomate
// ─────────────────────────────────────────────

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradproj/features/user/data/models/user_models.dart';
import 'package:gradproj/features/user/data/models/user_register_model.dart';
import 'package:gradproj/features/user/data/repositories/user_repository_impl.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;
  UserCubit(this._repository) : super(UserInitial());

  Future<void> registerUser(UserRegisterModel model) async {
    emit(UserLoading());
    final failure = await _repository.registerUser(model);
    if (failure != null) {
      emit(UserFailure(message: failure.message));
    } else {
      emit(UserRegisterSuccess());
    }
  }

  Future<void> loginUser(UserLoginModel model) async {
    emit(UserLoading());
    final result = await _repository.loginUser(model);
    if (result.failure != null) {
      emit(UserFailure(message: result.failure!.message));
    } else {
      emit(UserLoginSuccess(profile: result.profile!, token: result.token!));
    }
  }
}
