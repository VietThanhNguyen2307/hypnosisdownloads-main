part of 'create_playlist_cubit.dart';

abstract class CreatePlaylistState extends Equatable {
  const CreatePlaylistState();

  @override
  List<Object> get props => [];
}

class CreatePlaylistInitial extends CreatePlaylistState {}

class CreatePlaylistInProgress extends CreatePlaylistState {}

class CreatePlaylistSuccess extends CreatePlaylistState {}

class CreatePlaylistFailure extends CreatePlaylistState {
  const CreatePlaylistFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
