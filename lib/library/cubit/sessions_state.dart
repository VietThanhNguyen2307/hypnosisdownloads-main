part of 'sessions_cubit.dart';

abstract class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object> get props => [];
}

class SessionsInitial extends SessionsState {}

class SessionsLoadInProgress extends SessionsState {}

class SessionsLoadSuccess extends SessionsState {
  const SessionsLoadSuccess(this.session);

  final Session session;

  @override
  List<Object> get props => [session, identityHashCode(this)];
}

class SessionsLoadFailure extends SessionsState {
  const SessionsLoadFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
