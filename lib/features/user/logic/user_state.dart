part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserRegisterSuccess extends UserState {}

class UserLoginSuccess extends UserState {
  final UserProfile profile;
  final String token;
  const UserLoginSuccess({required this.profile, required this.token});
  @override
  List<Object?> get props => [profile, token];
}

class UserUpdateSuccess extends UserState {
  final UserProfile profile;
  const UserUpdateSuccess({required this.profile});
  @override
  List<Object?> get props => [profile];
}

class UserFailure extends UserState {
  final String message;
  const UserFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
