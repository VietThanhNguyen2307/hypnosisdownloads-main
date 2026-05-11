import 'dart:async';

import 'package:authentication_logic/authentication_logic.dart';
import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/data/playlists_repository.dart';

part 'playlists_state.dart';

class PlaylistsCubit extends Cubit<PlaylistsState> {
  PlaylistsCubit(this.playlistsRepository, this.currentUserRepository)
      : super(PlaylistsInitial());

  final PlaylistsRepository playlistsRepository;
  final CurrentUserRepository currentUserRepository;

  Future<void> onPageOpened() async {
    await _showPlaylists();
  }

  Future<void> _showPlaylists() async {
    try {
      emit(PlaylistsLoadInProgress());
      final playlists = await playlistsRepository.getPlaylists();
      emit(PlaylistsLoadSuccess(playlists));
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Playlists load failure',
        fatal: false,
      );
      emit(PlaylistsLoadFailure(parseErrorMessageFrom(error)));
    }
  }

  Future<void> delete(Playlist playlist) async {
    emit(const PlaylistDeleteInProgress());
    try {
      final user = currentUserRepository.currentUser;
      await playlistsRepository.deletePlaylist(
        name: user.email,
        password: user.accessToken,
        id: playlist.id,
      );
      emit(const PlaylistDeleteSuccess());
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Playlist delete failure',
        fatal: false,
      );
      emit(PlaylistDeleteFailure(parseErrorMessageFrom(error)));
    }
    unawaited(_showPlaylists());
  }
}
