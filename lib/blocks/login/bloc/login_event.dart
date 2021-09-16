part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginPressed extends LoginEvent {
  final LoginRequest request;
  LoginPressed({this.request});
}
class IsLoginnedBefore extends LoginEvent{}