import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/data/playlists_repository.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';

part 'remove_from_playlist_state.dart';

class RemoveFromPlaylistCubit extends Cubit<RemoveFromPlaylistState> {
  RemoveFromPlaylistCubit(this._playlistsRepository)
      : super(RemoveFromPlaylistInitial());

  final PlaylistsRepository _playlistsRepository;

  Future<void> removeFromPlaylist(Product audio, Playlist playlist) async {
    emit(const RemoveFromPlaylistInProgress());
    try {
      await _playlistsRepository.removeFromPlaylist(audio, playlist);
      emit(RemoveFromPlaylistSuccess(audio));
    } catch (e) {
      emit(RemoveFromPlaylistFailure(parseErrorMessageFrom(e)));
    }
    // unawaited(_showPlaylists());
  }
}
