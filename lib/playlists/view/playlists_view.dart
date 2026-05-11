import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/playlists/create_playlist/cubit/create_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/playlists/view/components/empty_playlists_view.dart';
import 'package:hypnosis_downloads/playlists/view/components/playlists_list_view.dart';
import 'package:hypnosis_downloads/search/playlists_search/playlists_search_bloc.dart';

class PlaylistsView extends StatelessWidget {
  const PlaylistsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistsCubit, PlaylistsState>(
      builder: (context, state) {
        if (state is PlaylistsLoadSuccess) {
          final playlists = state.playlists;

          context.read<CreatePlaylistCubit>().setPlaylists(playlists);
          context.read<PlaylistsSearchBloc>().fetchFromSource(playlists);
          if (playlists.isNotEmpty) {
            return BlocBuilder<PlaylistsSearchBloc, PlaylistsSearchState>(
              builder: (context, searchState) {
                if (searchState.searchQuery.isNotEmpty &&
                    searchState.searchResult.isEmpty) {
                  return Center(
                    child: Text(
                      'No search results for "${searchState.searchQuery}"',
                    ),
                  );
                } else {
                  return PlaylistsListView(
                      playlists: List.from(searchState.searchResult));
                }
              },
            );
          } else {
            return const EmptyPlaylistsView();
          }
        } else if (state is PlaylistsLoadInProgress) {
          return const Center(
            child: LoadingView(),
          );
        } else if (state is PlaylistsLoadFailure) {
          return Center(
            child: ErrorView(state.message),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
