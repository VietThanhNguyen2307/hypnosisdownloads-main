part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutStateInitial extends LogoutState {
  const LogoutStateInitial();
}

class LogoutInProgress extends LogoutState {
  const LogoutInProgress();
}

class LogoutSuccess extends LogoutState {
  const LogoutSuccess();
}

class LogoutFailure extends LogoutState {
  const LogoutFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
