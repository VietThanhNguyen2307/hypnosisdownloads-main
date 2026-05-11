import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/connectivity_status/logic/connectivity_status_cubit.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/view/components/playlist_audio_more_bottom_sheet.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/view/components/audio_more_bottom_sheet.dart';
import 'package:hypnosis_downloads/products/scripts/view/components/script_more_bottom_sheet.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AudioListViewItem extends StatelessWidget {
  const AudioListViewItem({
    Key? key,
    required this.downloadable,
    this.onTap,
    required this.onActionTap,
    required this.onCancel,
    this.playlist,
  }) : super(key: key);

  final Downloadable<Product> downloadable;
  final VoidCallback? onTap;
  final Function(Downloadable<Product>) onActionTap;
  final Function(Downloadable<Product>) onCancel;
  final Playlist? playlist;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.hypnosisAudioPlayer.currentAudioStream,
      builder: (BuildContext context, AsyncSnapshot<Product?> snapshot) {
        final isCurrentAudio = context.hypnosisAudioPlayer.currentAudio?.id ==
            downloadable.item.id;

        return BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
          builder: (context, state) {
            final isOnline = state is ConnectivityStatusOnline;
            final isDownloaded =
                downloadable.status == DownloadTaskStatus.complete.index ||
                    downloadable.downloadedPercent == 100;
            final isEnabled = isOnline || isDownloaded;
            return GestureDetector(
              onTap: isEnabled
                  ? onTap
                  : () {
                      if (!isOnline) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please go online to play or download audio'),
                          ),
                        );
                      }
                    },
              child: Opacity(
                opacity: isEnabled ? 1 : 0.75,
                child: SizedBox(
                  height: 48,
                  child: Center(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 2,
                            ),
                            SvgPicture.asset(
                              IconsBold.music,
                              color: isCurrentAudio
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: BodyMediumText(
                            downloadable.item.name,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            color: isCurrentAudio
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                        ),
                        const SizedBox(width: 20),
                        buildActions(
                          context,
                          downloadable,
                          onActionTap: onActionTap,
                          onCancel: onCancel,
                          playlist: playlist,
                          isCurrentAudio: isCurrentAudio,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget buildActions(
  BuildContext context,
  Downloadable<Product> downloadable, {
  required final Function(Downloadable<Product>) onActionTap,
  required final Function(Downloadable<Product>) onCancel,
  Playlist? playlist,
  bool isCurrentAudio = false,
}) {
  if (downloadable.status == DownloadTaskStatus.undefined.index ||
      downloadable.status == DownloadTaskStatus.canceled.index) {
    return BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
      builder: (context, state) {
        final isOnline = state is ConnectivityStatusOnline;
        return DefaultIconButton(
          SvgPicture.asset(
            key: const Key('Download'),
            IconsOutlined.download,
            color: isCurrentAudio ? Theme.of(context).primaryColor : null,
          ),
          isEnabled: isOnline,
          onTap: () => onActionTap.call(downloadable),
        );
      },
    );
  } else if (downloadable.status == DownloadTaskStatus.running.index) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: CircularPercentIndicator(
            radius: 15.0,
            lineWidth: 2.0,
            percent: downloadable.downloadedPercent / 100,
            center: Text(
              '${downloadable.downloadedPercent}%',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).primaryColor,
              ),
            ),
            progressColor: Colors.green,
          ),
        ),
        IconButton(
          key: const Key('Cancel'),
          onPressed: () => onActionTap.call(downloadable),
          constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
          icon: SvgPicture.asset(IconsOutlined.close),
          tooltip: 'Cancel',
        ),
      ],
    );
  } else if (downloadable.status == DownloadTaskStatus.complete.index) {
    if (downloadable.item.type == DownloadProductType.audio) {
      return DefaultIconButton(
        SvgPicture.asset(
          key: const Key('Menu'),
          IconsBold.more,
          color: isCurrentAudio ? Theme.of(context).primaryColor : null,
        ),
        onTap: () => CustomBottomModalSheet.showBottomSheet.call(
          context: context,
          builder: (context) => playlist != null
              ? PlaylistAudioMoreBottomSheet(
                  downloadable: downloadable,
                  playlist: playlist,
                  onActionTap: onActionTap,
                )
              : AudioMoreBottomSheet(
                  downloadable: downloadable,
                  onActionTap: onActionTap,
                ),
        ),
      );
    } else {
      return DefaultIconButton(
        SvgPicture.asset(
          key: const Key('Menu'),
          IconsBold.more,
        ),
        onTap: () => CustomBottomModalSheet.showBottomSheet.call(
          context: context,
          builder: (context) => ScriptMoreBottomSheet(
            downloadable: downloadable,
            onActionTap: onActionTap,
          ),
        ),
      );
    }
  } else if (downloadable.status == DownloadTaskStatus.failed.index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Failed', style: TextStyle(color: Colors.red)),
        IconButton(
          onPressed: () => onActionTap.call(downloadable),
          constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
          icon: const Icon(Icons.refresh, color: Colors.green),
          tooltip: 'Refresh',
        )
      ],
    );
  } else if (downloadable.status == DownloadTaskStatus.enqueued.index) {
    return Text('Pending',
        style: TextStyle(color: Theme.of(context).secondaryHeaderColor));
  } else {
    return nothing;
  }
}
