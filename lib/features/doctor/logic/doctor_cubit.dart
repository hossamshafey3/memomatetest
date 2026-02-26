// ─────────────────────────────────────────────
//  doctor_cubit.dart  –  Memomate
//  Cubit + States for Doctor registration.
// ─────────────────────────────────────────────

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradproj/features/doctor/data/models/doctor_model.dart';
import 'package:gradproj/features/doctor/data/repositories/doctor_repository_impl.dart';

part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final DoctorRepository _repository;

  DoctorCubit(this._repository) : super(DoctorInitial());

  Future<void> registerDoctor(DoctorRegisterModel model) async {
    emit(DoctorLoading());

    final result = await _repository.registerDoctor(model);

    if (result.failure != null) {
      emit(DoctorFailure(message: result.failure!.message));
    } else {
      emit(DoctorLoginSuccess(profile: result.profile!));
    }
  }

  Future<void> loginDoctor(DoctorLoginModel model) async {
    emit(DoctorLoading());

    final result = await _repository.loginDoctor(model);

    if (result.failure != null) {
      emit(DoctorFailure(message: result.failure!.message));
    } else {
      emit(DoctorLoginSuccess(profile: result.profile!));
    }
  }

  Future<void> updateDoctor(String id, Map<String, dynamic> fields) async {
    emit(DoctorLoading());

    final result = await _repository.updateDoctor(id, fields);

    if (result.failure != null) {
      emit(DoctorFailure(message: result.failure!.message));
    } else {
      emit(DoctorUpdateSuccess(profile: result.profile!));
    }
  }
}
