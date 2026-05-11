import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/common/filtering_mode.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';

part 'playlists_search_event.dart';
part 'playlists_search_state.dart';

class PlaylistsSearchBloc
    extends Bloc<PlaylistsSearchEvent, PlaylistsSearchState> {
  PlaylistsSearchBloc() : super(PlaylistsSearchState.initial()) {
    on<PlaylistsSearchQueryChanged>(_onQueryChanged);
    on<PlaylistsSearchFilterChanged>(_onFilterChanged);
    on<PlaylistsSearchReset>(_onReset);
    on<PlaylistsFetchFromSource>(_onPlaylistsFetchFromSource);
    on<PlaylistsSearchLogout>(onLogout);
  }

  void _onPlaylistsFetchFromSource(
    PlaylistsFetchFromSource event,
    Emitter<PlaylistsSearchState> emit,
  ) {
    // debugPrint('playlists: ${event.playlists}');
    emit(
      state.copyWith(
        playlists: event.playlists,
        searchResult: event.playlists,
        filterResult: event.playlists,
      ),
    );
  }

  void _onQueryChanged(
    PlaylistsSearchQueryChanged event,
    Emitter<PlaylistsSearchState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(state.copyWith(
        searchQuery: event.query,
        searchResult: state.playlists,
      ));
      return;
    }
    final queryFilterResult = state.playlists
        .where(
          (playlist) =>
              playlist.name.toLowerCase().contains(event.query.toLowerCase()),
        )
        .toList();

    emit(state.copyWith(
      searchQuery: event.query,
      searchResult: queryFilterResult,
    ));
  }

  void _onFilterChanged(
    PlaylistsSearchFilterChanged event,
    Emitter<PlaylistsSearchState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  void _onReset(
    PlaylistsSearchReset event,
    Emitter<PlaylistsSearchState> emit,
  ) {
    emit(state.copyWith(searchQuery: '', searchResult: state.playlists));
  }

  void fetchFromSource(List<Playlist> playlists) {
    add(PlaylistsFetchFromSource(playlists));
  }

  void onQueryChanged(String query) {
    add(PlaylistsSearchQueryChanged(query));
  }

  void onFilterChanged(FilteringMode filter) {
    add(PlaylistsSearchFilterChanged(filter));
  }

  Future<void> clear() async {
    add(PlaylistsSearchReset());
  }

  Future<void> onLogout(
    PlaylistsSearchLogout event,
    Emitter<PlaylistsSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PlaylistsSearchStatus.initial,
        playlists: [],
        searchResult: [],
        filter: FilteringMode.none,
        searchQuery: '',
        errorMessage: '',
      ),
    );
    state.playlists.clear();
    state.searchResult.clear();
  }

  // List<Playlist> sortPlaylists(List<Playlist> playlists,
  //     {PlaylistsSortState filter = PlaylistsSortState.none}) {
  //   switch (filter) {
  //     case PlaylistsSortState.none:
  //       return playlists;
  //     case PlaylistsSortState.alphabet:
  //       return playlists.where((playlist) => playlist.name.isNotEmpty).toList()
  //         ..sort(
  //             (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  //     case PlaylistsSortState.aplhabetReverse:
  //       return playlists.where((playlist) => playlist.name.isNotEmpty).toList()
  //         ..sort(
  //             (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
  //     case PlaylistsSortState.date:
  //       return playlists.where((playlist) => playlist.name.isNotEmpty).toList()
  //         ..sort((a, b) => (b.createdAt ?? DateTime.now())
  //             .compareTo(a.createdAt ?? DateTime.now()));
  //   }
  // }
}
