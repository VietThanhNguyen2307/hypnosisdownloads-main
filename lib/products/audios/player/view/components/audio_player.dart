import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/components/play_button.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    Key? key,
    required this.audioPack,
    required this.playlist,
    required this.audio,
  }) : super(key: key);

  final ProductPack? audioPack;
  final Playlist? playlist;
  final Product audio;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool loading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentAudio = context.hypnosisAudioPlayer.currentAudio;
      final widgetAudio = widget.audio;
      if (currentAudio?.id != widgetAudio.id) {
        await context.hypnosisAudioPlayer.stop();

        setState(() {
          loading = false;
        });
        if (widget.audioPack != null) {
          await context.hypnosisAudioPlayer.setPackAudioSource(
              widget.audioPack!,
              initialIndex: widget.audioPack!.products.indexOf(widget.audio),
              useOfflineLinkIfAvailable: (product) async {
            final context = NavigationService.navigatorKey.currentContext!;
            final downloadableProductsCubit =
                context.read<DownloadableProductsCubit>();
            final downloadable = await downloadableProductsCubit
                .getDownloadStatusForSingle(product);
            if (downloadable.status == DownloadTaskStatus.complete.index) {
              return downloadable.item.copyWith(link: downloadable.offlineUrl);
            } else {
              return product;
            }
          });
        } else if (widget.playlist != null) {
          await context.hypnosisAudioPlayer.setPlaylistAudioSource(
              widget.playlist!,
              initialIndex: widget.playlist!.products.indexOf(widget.audio),
              useOfflineLinkIfAvailable: (product) async {
            final context = NavigationService.navigatorKey.currentContext!;
            final downloadableProductsCubit =
                context.read<DownloadableProductsCubit>();
            final downloadable = await downloadableProductsCubit
                .getDownloadStatusForSingle(product);
            if (downloadable.status == DownloadTaskStatus.complete.index) {
              return downloadable.item.copyWith(link: downloadable.offlineUrl);
            } else {
              return product;
            }
          });
        }
      } else {
        setState(() {
          loading = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AudioPlayerTrack(
          audio: widget.audio,
          loading: loading,
        ),
        const SizedBox(height: 32),
        AudioPlayerActions(
          audio: widget.audio,
        ),
      ],
    );
  }
}

class AudioPlayerActions extends StatefulWidget {
  const AudioPlayerActions({
    Key? key,
    required this.audio,
  }) : super(key: key);

  final Product audio;

  @override
  State<AudioPlayerActions> createState() => _AudioPlayerActionsState();
}

class _AudioPlayerActionsState extends State<AudioPlayerActions> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.hypnosisAudioPlayer.playerStateStream,
        builder: (
          BuildContext context,
          AsyncSnapshot<PlayerState> playerStateSnapshot,
        ) {
          final playerState = playerStateSnapshot.data;
          final processingState = playerState?.processingState;
          final playing = playerState?.playing == true;
          final buffering = processingState == ProcessingState.buffering;
          final loading = processingState == ProcessingState.loading;

          if (loading || buffering) {
            return const CustomLoadingIndicator(size: 48);
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Opacity(
                opacity:
                    !loading && context.hypnosisAudioPlayer.canSeekToPrevious
                        ? 1
                        : .5,
                child: AbsorbPointer(
                  absorbing: loading,
                  child: DefaultIconButton.large(
                    SvgPicture.asset(
                      key: const Key('Previous'),
                      IconsBold.previous,
                      color: ComponentColors.defaultIconColor,
                    ),
                    onTap: () => context.hypnosisAudioPlayer.canSeekToPrevious
                        ? context.hypnosisAudioPlayer.seekToPrevious()
                        : null,
                  ),
                ),
              ),
              Opacity(
                opacity: loading ? .5 : 1,
                child: AbsorbPointer(
                  absorbing: loading,
                  child: DefaultIconButton.largest(
                    SvgPicture.asset(
                      IconsOutlined.backward10Seconds,
                      color: ComponentColors.defaultIconColor,
                    ),
                    onTap: () => loading
                        ? null
                        : context.hypnosisAudioPlayer.backward10Seconds(),
                  ),
                ),
              ),
              PlayButton(
                playing: playing,
                onTap: () {
                  if (playing) {
                    context.hypnosisAudioPlayer.pause();
                  } else {
                    context.hypnosisAudioPlayer.play();
                  }
                },
              ),
              AbsorbPointer(
                absorbing: loading,
                child: loading
                    ? const CustomLoadingIndicator(size: 48)
                    : DefaultIconButton.largest(
                        SvgPicture.asset(
                          IconsOutlined.forward10Seconds,
                          color: ComponentColors.defaultIconColor,
                        ),
                        onTap: () => loading
                            ? null
                            : context.hypnosisAudioPlayer.forward10Seconds(),
                      ),
              ),
              Opacity(
                opacity: !loading && context.hypnosisAudioPlayer.canSeekToNext
                    ? 1
                    : .5,
                child: AbsorbPointer(
                  absorbing: loading,
                  child: DefaultIconButton.large(
                    SvgPicture.asset(
                      key: const Key('Next'),
                      IconsBold.next,
                      color: ComponentColors.defaultIconColor,
                    ),
                    onTap: () => context.hypnosisAudioPlayer.canSeekToNext
                        ? context.hypnosisAudioPlayer.seekToNext()
                        : null,
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class AudioPlayerTrack extends StatefulWidget {
  const AudioPlayerTrack({
    Key? key,
    required this.audio,
    required this.loading,
  }) : super(key: key);

  final Product audio;
  final bool loading;

  @override
  State<AudioPlayerTrack> createState() => _AudioPlayerTrackState();
}

class _AudioPlayerTrackState extends State<AudioPlayerTrack> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.hypnosisAudioPlayer.durationStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<Duration?> durationSnapshot,
      ) {
        return StreamBuilder(
          stream: context.hypnosisAudioPlayer.positionStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<Duration> positionSnapshot,
          ) {
            return Opacity(
              opacity: widget.loading ? .5 : 1,
              child: AbsorbPointer(
                absorbing: widget.loading,
                child: Column(
                  children: [
                    ProgressBar(
                      progress: positionSnapshot.data ?? Duration.zero,
                      total: durationSnapshot.data ?? Duration.zero,
                      thumbRadius: 6,
                      timeLabelTextStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: ComponentColors.defaultBodyTextColor,
                              ),
                      baseBarColor: ComponentColors.sliderInactiveColor,
                      timeLabelPadding: 8,
                      onSeek: (position) =>
                          context.hypnosisAudioPlayer.seek(position),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
