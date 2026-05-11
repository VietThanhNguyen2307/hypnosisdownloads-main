part of 'add_to_playlist_cubit.dart';

abstract class AddToPlaylistState extends Equatable {
  const AddToPlaylistState();

  @override
  List<Object> get props => [];
}

class AddToPlaylistInitial extends AddToPlaylistState {}

class AddToPlaylistInProgress extends AddToPlaylistState {
  const AddToPlaylistInProgress(this.audio);

  final Product audio;

  @override
  List<Object> get props => [audio];
}

class AddToPlaylistSuccess extends AddToPlaylistState {
  const AddToPlaylistSuccess(this.playlistName);

  final String playlistName;

  @override
  List<Object> get props => [playlistName];
}

class AddToPlaylistFailure extends AddToPlaylistState {
  const AddToPlaylistFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
