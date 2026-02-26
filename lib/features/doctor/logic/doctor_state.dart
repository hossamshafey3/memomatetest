part of 'doctor_cubit.dart';

abstract class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object?> get props => [];
}

/// Initial / idle state.
class DoctorInitial extends DoctorState {}

/// API call in progress.
class DoctorLoading extends DoctorState {}

/// Registration completed successfully.
class DoctorSuccess extends DoctorState {}

/// Login completed successfully — carries the doctor's profile.
class DoctorLoginSuccess extends DoctorState {
  final DoctorProfile profile;
  const DoctorLoginSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Profile update completed successfully — carries the updated profile.
class DoctorUpdateSuccess extends DoctorState {
  final DoctorProfile profile;
  const DoctorUpdateSuccess({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Registration failed with an error message.
class DoctorFailure extends DoctorState {
  final String message;
  const DoctorFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
