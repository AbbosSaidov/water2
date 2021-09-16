part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {}

class LoginInitial extends LoginState {}

class LoginFailed extends LoginState {}

class LoginLoaded extends LoginState{
  final LoginResponse response;
  LoginLoaded({
    @required this.response,
  });
}
class Loginned extends LoginState{}
