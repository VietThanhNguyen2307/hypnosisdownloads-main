part of 'playlists_cubit.dart';

abstract class PlaylistsState extends Equatable {
  const PlaylistsState();

  @override
  List<Object?> get props => [];
}

class PlaylistsInitial extends PlaylistsState {}

class PlaylistsLoadInProgress extends PlaylistsState {}

class PlaylistsLoadSuccess extends PlaylistsState {
  const PlaylistsLoadSuccess(this.playlists);

  final List<Playlist> playlists;

  @override
  List<Object> get props => [playlists];
}

class PlaylistsLoadFailure extends PlaylistsState {
  const PlaylistsLoadFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class PlaylistDeleteInProgress extends PlaylistsState {
  const PlaylistDeleteInProgress();
}

class PlaylistDeleteSuccess extends PlaylistsState {
  const PlaylistDeleteSuccess();
}

class PlaylistDeleteFailure extends PlaylistsState {
  const PlaylistDeleteFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
