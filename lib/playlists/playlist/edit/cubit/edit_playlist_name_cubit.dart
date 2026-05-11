import 'package:authentication_logic/authentication_logic.dart';
import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/data/playlists_repository.dart';

part 'edit_playlist_name_state.dart';

class EditPlaylistNameCubit extends Cubit<EditPlaylistNameState> {
  EditPlaylistNameCubit(
    this.playlistsRepository,
    this.currentUserRepository,
  ) : super(EditPlaylistNameInitial());

  final PlaylistsRepository playlistsRepository;
  final CurrentUserRepository currentUserRepository;

  Future<void> saveName(String name, Playlist playlist) async {
    try {
      emit(SaveNameInProgress());
      if (name.isEmpty) {
        emit(const SaveNameFailure('Name cannot be empty'));
        return;
      }

      final user = currentUserRepository.currentUser;
      await playlistsRepository.savePlaylistName(
        username: user.email,
        password: user.accessToken,
        playlistName: name,
        playlist: playlist,
      );

      await Hive.box<Playlist>('playlists').put(
        playlist.id,
        playlist.copyWith(name: name),
      );

      emit(SaveNameSuccess());
    } catch (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: 'Playlist name save failure',
        fatal: false,
      );
      emit(SaveNameFailure(parseErrorMessageFrom(error)));
    }
  }
}
