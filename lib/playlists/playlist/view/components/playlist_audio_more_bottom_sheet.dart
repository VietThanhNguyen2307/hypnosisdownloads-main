import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_bottom_sheet_skeleton.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/common/remove_from_playlist/cubit/remove_from_playlist_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/view/components/delete_confirmation_bottom_sheet.dart';
import 'package:hypnosis_downloads/library/view/components/product_details_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PlaylistAudioMoreBottomSheet extends StatefulWidget {
  const PlaylistAudioMoreBottomSheet({
    Key? key,
    required this.downloadable,
    required this.playlist,
    required this.onActionTap,
  }) : super(key: key);

  final Downloadable<Product> downloadable;
  final Playlist playlist;
  final Function(Downloadable<Product>) onActionTap;

  @override
  State<PlaylistAudioMoreBottomSheet> createState() =>
      _PlaylistAudioMoreBottomSheetState();
}

class _PlaylistAudioMoreBottomSheetState
    extends State<PlaylistAudioMoreBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheetSkeleton(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: HeadlineMediumText.dark(
                  '${widget.downloadable.item.name}.mp3',
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          buildActionWidget(
            icon: SvgPicture.asset(IconsOutlined.delete),
            text: 'Delete from playlist',
            onTap: () => context
                .read<RemoveFromPlaylistCubit>()
                .removeFromPlaylist(widget.downloadable.item, widget.playlist)
                .whenComplete(() {
              Navigator.of(context).pop();
            }),
          ),
          buildActionWidget(
            icon: SvgPicture.asset(IconsOutlined.note),
            text: 'Details',
            onTap: () {
              Navigator.of(context).pop();
              CustomBottomModalSheet.showBottomSheet.call(
                context: context,
                builder: (context) => ProductDetailsBottomSheet(
                    product: widget.downloadable.item),
              );
            },
          ),
          buildActionDeleteWidget(
            icon: SvgPicture.asset(
              IconsOutlined.trash,
              color: ComponentColors.errorIconColor,
            ),
            text: 'Delete',
            onTap: () async {
              final action = (await CustomBottomModalSheet.showBottomSheet.call(
                context: context,
                builder: (context) => DeleteConfirmationBottomSheet(
                  downloadable: widget.downloadable,
                ),
              )) as DeleteConfirmationAction?;

              if (action == DeleteConfirmationAction.delete) {
                widget.onActionTap.call(widget.downloadable);
                if (mounted) Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  Widget buildActionWidget({
    required Widget icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 24,
                child: icon,
              ),
              const SizedBox(width: 12),
              BodyMediumText.dark(text),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionDeleteWidget({
    required Widget icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 24,
                child: icon,
              ),
              const SizedBox(width: 12),
              BodyMediumText.error(text),
            ],
          ),
        ),
      ),
    );
  }
}
