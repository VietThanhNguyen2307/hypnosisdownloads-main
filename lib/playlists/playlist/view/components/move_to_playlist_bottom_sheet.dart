import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_bottom_sheet_skeleton.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/add_to_playlist/cubit/cubit/add_to_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/view/components/playlists_list_view.dart';

import '../../../../library/data/model/product.dart';

class MoveToPlaylistBottomSheet extends StatelessWidget {
  const MoveToPlaylistBottomSheet({Key? key, required this.audio})
      : super(key: key);

  final Product audio;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheetSkeleton(
      child: BlocBuilder<PlaylistsCubit, PlaylistsState>(
        builder: (context, state) {
          if (state is PlaylistsLoadSuccess) {
            final playlists = state.playlists;

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: List<Widget>.generate(
                    playlists.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PlaylistsListViewItem(
                        playlist: playlists.elementAt(index),
                        onTap: () {
                          Navigator.of(context).pop();
                          context.read<AddToPlaylistCubit>().addToPlaylist(
                                audio,
                                playlists.elementAt(index),
                              );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return nothing;
          }
        },
      ),
    );
  }
}
