part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginAuthEvent extends LoginEvent {
  final LoginModel login;
  LoginAuthEvent (this.login);
}
