import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradproj/features/doctor/data/models/doctor_model.dart';
import 'package:gradproj/features/user/data/repositories/user_repository_impl.dart';

part 'doctors_list_state.dart';

class DoctorsListCubit extends Cubit<DoctorsListState> {
  final UserRepository _repository;

  DoctorsListCubit(this._repository) : super(DoctorsListInitial());

  Future<void> fetchDoctors(String token) async {
    emit(DoctorsListLoading());
    final result = await _repository.getAllDoctors(token);

    if (result.failure != null) {
      emit(DoctorsListFailure(message: result.failure!.message));
    } else {
      emit(DoctorsListSuccess(doctors: result.doctors ?? []));
    }
  }
}
