part of 'playlists_search_bloc.dart';

enum PlaylistsSearchStatus { initial, loading, success, failure }

enum PlaylistsSortState { none, alphabet, aplhabetReverse, date }

class PlaylistsSearchState extends Equatable {
  const PlaylistsSearchState({
    this.status = PlaylistsSearchStatus.initial,
    this.playlists = const [],
    this.searchResult = const [],
    this.filter = FilteringMode.none,
    this.searchQuery = '',
    this.errorMessage = '',
  });

  factory PlaylistsSearchState.initial() => const PlaylistsSearchState();

  final PlaylistsSearchStatus status;
  final List<Playlist> playlists;
  final List<Playlist> searchResult;

  final FilteringMode filter;
  final String searchQuery;
  final String errorMessage;

  PlaylistsSearchState copyWith({
    PlaylistsSearchStatus? status,
    List<Playlist>? playlists,
    List<Playlist>? searchResult,
    List<Playlist>? filterResult,
    FilteringMode? filter,
    String? searchQuery,
    String? errorMessage,
  }) =>
      PlaylistsSearchState(
        status: status ?? this.status,
        playlists: playlists ?? this.playlists,
        searchResult: searchResult ?? this.searchResult,
        filter: filter ?? this.filter,
        searchQuery: searchQuery ?? this.searchQuery,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, playlists, searchResult, filter, searchQuery, errorMessage];
}
