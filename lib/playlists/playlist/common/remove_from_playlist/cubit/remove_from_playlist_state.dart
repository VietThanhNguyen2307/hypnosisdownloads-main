part of 'remove_from_playlist_cubit.dart';

abstract class RemoveFromPlaylistState extends Equatable {
  const RemoveFromPlaylistState();

  @override
  List<Object> get props => [];
}

class RemoveFromPlaylistInitial extends RemoveFromPlaylistState {}

class RemoveFromPlaylistInProgress extends RemoveFromPlaylistState {
  const RemoveFromPlaylistInProgress();
}

class RemoveFromPlaylistSuccess extends RemoveFromPlaylistState {
  const RemoveFromPlaylistSuccess(this.audio);

  final Product audio;

  @override
  List<Object> get props => [];
}

class RemoveFromPlaylistFailure extends RemoveFromPlaylistState {
  const RemoveFromPlaylistFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
