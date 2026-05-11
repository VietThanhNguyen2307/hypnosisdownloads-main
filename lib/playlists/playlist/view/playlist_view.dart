import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/components/play_button.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/label_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/add_to_playlist/add_to_playlist_page.dart';
import 'package:hypnosis_downloads/playlists/playlist/common/remove_from_playlist/cubit/remove_from_playlist_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/view/products_list_view.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({Key? key, required this.initialPlaylist})
      : super(key: key);

  final Playlist initialPlaylist;

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    return widget.initialPlaylist.products.isNotEmpty
        ? NonEmptyPlaylistView(widget.initialPlaylist)
        : EmptyPlaylistView(playlist: widget.initialPlaylist);
  }
}

class NonEmptyPlaylistView extends StatefulWidget {
  const NonEmptyPlaylistView(this.playlist, {super.key});

  final Playlist playlist;

  @override
  State<NonEmptyPlaylistView> createState() => _NonEmptyPlaylistViewState();
}

class _NonEmptyPlaylistViewState extends State<NonEmptyPlaylistView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RemoveFromPlaylistCubit, RemoveFromPlaylistState>(
      listener: (context, state) {
        if (state is RemoveFromPlaylistSuccess) {
          setState(() {
            widget.playlist.copyWith(
                products: widget.playlist.products..remove(state.audio));
          });
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 300),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SizedBox.square(
                                    dimension: 50,
                                    child: SvgPicture.asset(
                                      IconsBold.music,
                                      color: ComponentColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: HeadlineMediumText.dark(
                                      widget.playlist.name,
                                    ),
                                  ),
                                ],
                              ),
                              LabelText(
                                '${widget.playlist.products.length} files',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _renderPlayButton(context),
                  const SizedBox(height: 16),
                  ProductsListView(
                    pack: null,
                    playlist: widget.playlist,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12) +
                      const EdgeInsets.only(bottom: 140),
              child: PrimaryButton(
                'Add more items',
                onTap: () => NavigationService.navigatorKey.currentState?.push(
                  AddToPlaylistPage.route(widget.playlist),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderPlayButton(BuildContext context) {
    return StreamBuilder(
      stream: context.hypnosisAudioPlayer.playerStateStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<PlayerState> playerStateSnapshot,
      ) {
        final isCurrentPlaylist =
            context.hypnosisAudioPlayer.audioSource?.id == widget.playlist.id;
        final playerState = playerStateSnapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing == true;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const CustomLoadingIndicator(size: 48);
        }

        if (isCurrentPlaylist &&
            (processingState != ProcessingState.buffering ||
                processingState != ProcessingState.loading)) {
          context.hypnosisAudioPlayer.show();
        }

        return PlayButton(
          playing: playing && isCurrentPlaylist,
          onTap: () async {
            if (isCurrentPlaylist) {
              if (playing) {
                await context.hypnosisAudioPlayer.pause();
              } else {
                await context.hypnosisAudioPlayer.play();
              }
            } else {
              await _setCurrentPlaylist();
            }
          },
        );
      },
    );
  }

  Future<void> _setCurrentPlaylist() async {
    await context.hypnosisAudioPlayer.setPlaylistAudioSource(
      widget.playlist,
      useOfflineLinkIfAvailable: (product) async {
        if (!mounted) return product;
        final downloadableProductsCubit =
            context.read<DownloadableProductsCubit>();
        final downloadable =
            await downloadableProductsCubit.getDownloadStatusForSingle(product);
        if (downloadable.status == DownloadTaskStatus.complete.index) {
          return downloadable.item.copyWith(link: downloadable.offlineUrl);
        } else {
          return product;
        }
      },
    );
  }
}

class EmptyPlaylistView extends StatelessWidget {
  const EmptyPlaylistView({Key? key, required this.playlist}) : super(key: key);

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BodyMediumText('Let’s add the first audio to the playlist'),
            const SizedBox(height: 24),
            PrimaryButton(
              'Add audios',
              onTap: () => NavigationService.navigatorKey.currentState?.push(
                AddToPlaylistPage.route(playlist),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
