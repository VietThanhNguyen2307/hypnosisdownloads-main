part of 'connectivity_status_cubit.dart';

abstract class ConnectivityStatusState extends Equatable {
  const ConnectivityStatusState();

  @override
  List<Object?> get props => [];
}

class ConnectivityStatusStateInitial extends ConnectivityStatusState {
  const ConnectivityStatusStateInitial();
}

class ConnectivityStatusLoadInProgress extends ConnectivityStatusState {
  const ConnectivityStatusLoadInProgress();
}

class ConnectivityStatusOnline extends ConnectivityStatusState {
  const ConnectivityStatusOnline();
}

class ConnectivityStatusOffline extends ConnectivityStatusState {
  const ConnectivityStatusOffline();
}

class ConnectivityStatusLoadFailure extends ConnectivityStatusState {
  const ConnectivityStatusLoadFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
