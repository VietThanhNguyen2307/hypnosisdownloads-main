part of 'restore_password_cubit.dart';

abstract class RestorePasswordState extends Equatable {
  const RestorePasswordState();

  @override
  List<Object?> get props => [];
}

class RequestVerificationStateInitial extends RestorePasswordState {
  const RequestVerificationStateInitial();
}

class RequestVerificationInProgress extends RestorePasswordState {
  const RequestVerificationInProgress();
}

class RequestVerificationSuccess extends RestorePasswordState {
  const RequestVerificationSuccess();

  @override
  List<Object?> get props => [];
}

class RequestVerificationFailure extends RestorePasswordState {
  const RequestVerificationFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class ChangePasswordStateInitial extends RestorePasswordState {
  const ChangePasswordStateInitial();
}

class ChangePasswordInProgress extends RestorePasswordState {
  const ChangePasswordInProgress();
}

class ChangePasswordSuccess extends RestorePasswordState {
  const ChangePasswordSuccess();

  @override
  List<Object?> get props => [];
}

class ChangePasswordFailure extends RestorePasswordState {
  const ChangePasswordFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
