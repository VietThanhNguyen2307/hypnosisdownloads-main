import 'package:authentication_logic/authentication_logic.dart';
import 'package:equatable/equatable.dart';
import 'package:error_handling/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/data/playlists_repository.dart';

part 'create_playlist_state.dart';

class CreatePlaylistCubit extends Cubit<CreatePlaylistState> {
  CreatePlaylistCubit(
    this.playlistsRepository,
    this.currentUserRepository,
  ) : super(CreatePlaylistInitial());

  final PlaylistsRepository playlistsRepository;
  final CurrentUserRepository currentUserRepository;

  List<Playlist> playlists = [];

  Future<void> setPlaylists(List<Playlist> playlists) async {
    this.playlists = playlists;
  }

  Future<void> onCreatePlaylist(String playlistName) async {
    emit(CreatePlaylistInProgress());
    try {
      final defaultplaylistNameRegex =
          RegExp(r'^(?:s|My new playlist (\x{2116}|№)[\d]+)$');

      int listNumber = 0;

      if (playlistName.isEmpty) {
        try {
          final defaultPlaylists = Hive.box<Playlist>('playlists')
              .values
              .where(
                  (element) => defaultplaylistNameRegex.hasMatch(element.name))
              .toList();

          final List<int> defaultPlaylistsNumbers = defaultPlaylists
              .map((e) => int.parse(e.name.replaceAll(
                  RegExp(r'(?:s|My new playlist (\x{2116}|№))'), '')))
              .toList();

          listNumber = getNextIndex(defaultPlaylistsNumbers);
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      final user = currentUserRepository.currentUser;
      await playlistsRepository.saveNewPlaylist(
        name: user.email,
        password: user.accessToken,
        playlistName: playlistName,
        listNumber: listNumber,
      );

      // Hive.box<Playlist>('playlists').add();

      emit(CreatePlaylistSuccess());
    } catch (e) {
      emit(CreatePlaylistFailure(parseErrorMessageFrom(e)));
    }
  }

  int getNextIndex(List<int> numbers) {
    if (numbers.isEmpty) {
      return 1;
    }

    numbers.sort();

    for (int i = 0; i < numbers.length; i++) {
      if (i + 1 < numbers.length && numbers[i] + 1 != numbers[i + 1]) {
        return numbers[i] + 1;
      }
    }

    return numbers.last + 1;
  }
}
