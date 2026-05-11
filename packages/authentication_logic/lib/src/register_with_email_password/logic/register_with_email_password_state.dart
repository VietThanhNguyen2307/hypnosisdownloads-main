part of 'register_with_email_password_cubit.dart';

abstract class AuthRegisterState extends Equatable {
  const AuthRegisterState();

  @override
  List<Object?> get props => [];
}

class AuthRegisterStateInitial extends AuthRegisterState {
  const AuthRegisterStateInitial();
}

class AuthRegisterInProgress extends AuthRegisterState {
  const AuthRegisterInProgress();
}

class AuthRegisterSuccess extends AuthRegisterState {
  const AuthRegisterSuccess();
}

class AuthRegisterFailure extends AuthRegisterState {
  const AuthRegisterFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
