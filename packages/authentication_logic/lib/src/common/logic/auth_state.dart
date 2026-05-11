import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthInProgress extends AuthState {
  const AuthInProgress();
}

class LoginSuccess extends AuthState {
  const LoginSuccess();
}

class RegisterSuccess extends AuthState {
  const RegisterSuccess();
}

class AuthFailure extends AuthState {
  const AuthFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
