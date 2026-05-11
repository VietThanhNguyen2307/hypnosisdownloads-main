import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/home/routes/playlists_routes.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/components/successful_snackbar.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/common/remove_from_playlist/cubit/remove_from_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/edit/cubit/edit_playlist_name_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/view/components/playlist_more_bottom_sheet.dart';
import 'package:hypnosis_downloads/playlists/playlist/view/playlist_view.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({
    required this.initialPlaylist,
    super.key,
  });

  final Playlist initialPlaylist;

  static Page<void> page(Playlist initialPlaylist) => MaterialPage<void>(
        child: PlaylistPage(
          initialPlaylist: initialPlaylist,
        ),
      );

  static MaterialPageRoute<dynamic> route(Playlist initialPlaylist) =>
      MaterialPageRoute(
        builder: (context) => PlaylistPage(
          initialPlaylist: initialPlaylist,
        ),
      );

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Playlist playlist;

  @override
  void initState() {
    playlist = widget.initialPlaylist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<EditPlaylistNameCubit, EditPlaylistNameState>(
          listener: (context, state) {
            if (state is SaveNameSuccess) {
              Navigator.of(context).pushNamed(playlistNameChangedRouteName);
            }
          },
        ),
        BlocListener<RemoveFromPlaylistCubit, RemoveFromPlaylistState>(
          listener: (context, state) {
            if (state is RemoveFromPlaylistFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            }

            if (!context.loaderOverlay.overlayController.visibilityController
                .isClosed) {
              if (state is RemoveFromPlaylistInProgress) {
                context.loaderOverlay.overlayController.visibilityController
                    .isClosed;
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
            }
          },
        ),
        BlocListener<PlaylistsCubit, PlaylistsState>(
          listener: (context, state) {
            if (state is PlaylistDeleteSuccess) {
              Navigator.of(context).pushNamed(playlistDeletedRouteName);

              SuccessfulSnackbar.show(
                context,
                'Playlist deleted',
              );
            }
            if (state is PlaylistDeleteFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                ),
              );
            }

            if (state is PlaylistsLoadSuccess) {
              try {
                final updatedPlaylist = state.playlists.firstWhere(
                  (element) => element.id == playlist.id,
                );
                setState(() {
                  playlist = updatedPlaylist;
                });
                unawaited(context
                    .read<DownloadableProductsCubit>()
                    .onPageOpened(playlist.products));
              } on StateError catch (e) {
                // playlist was deleted, do nothing
                print(e);
              }
            }
          },
        ),
      ],
      child: CustomLoaderOverlay(
        child: Scaffold(
          extendBodyBehindAppBar: playlist.products.isEmpty,
          appBar: CustomAppBar.secondary(
            title: playlist.name,
            centerTitle: false,
            actions: [
              DefaultIconButton(
                SvgPicture.asset(IconsBold.more),
                onTap: () => CustomBottomModalSheet.showBottomSheet.call(
                  context: context,
                  builder: (context) => PlaylistMoreBottomSheet(
                    playlist: playlist,
                  ),
                ),
              ),
            ],
          ),
          body: PlaylistView(initialPlaylist: playlist),
          bottomNavigationBar: const SizedBox(),
        ),
      ),
    );
  }
}
