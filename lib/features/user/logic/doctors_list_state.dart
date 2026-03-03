part of 'doctors_list_cubit.dart';

abstract class DoctorsListState extends Equatable {
  const DoctorsListState();

  @override
  List<Object?> get props => [];
}

class DoctorsListInitial extends DoctorsListState {}

class DoctorsListLoading extends DoctorsListState {}

class DoctorsListSuccess extends DoctorsListState {
  final List<DoctorProfile> doctors;

  const DoctorsListSuccess({required this.doctors});

  @override
  List<Object?> get props => [doctors];
}

class DoctorsListFailure extends DoctorsListState {
  final String message;

  const DoctorsListFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
