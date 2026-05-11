part of 'playlists_search_bloc.dart';

abstract class PlaylistsSearchEvent extends Equatable {
  const PlaylistsSearchEvent();

  @override
  List<Object> get props => [];
}

class PlaylistsSearchQueryChanged extends PlaylistsSearchEvent {
  const PlaylistsSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class PlaylistsSearchFilterChanged extends PlaylistsSearchEvent {
  const PlaylistsSearchFilterChanged(this.filter);

  final FilteringMode filter;

  @override
  List<Object> get props => [filter];
}

class PlaylistsSearchReset extends PlaylistsSearchEvent {}

class PlaylistsFetchFromSource extends PlaylistsSearchEvent {
  const PlaylistsFetchFromSource(this.playlists);

  final List<Playlist> playlists;

  @override
  List<Object> get props => [playlists];
}

class PlaylistsSearchLogout extends PlaylistsSearchEvent {
  const PlaylistsSearchLogout();
}
