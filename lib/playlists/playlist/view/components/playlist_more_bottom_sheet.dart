import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_bottom_sheet_skeleton.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/edit/playlist_edit_page.dart';
import 'package:hypnosis_downloads/playlists/playlist/view/components/playlist_delete_confirmation_bottom_sheet.dart';
import 'package:provider/provider.dart';

class PlaylistMoreBottomSheet extends StatefulWidget {
  const PlaylistMoreBottomSheet({Key? key, required this.playlist})
      : super(key: key);

  final Playlist playlist;

  @override
  State<PlaylistMoreBottomSheet> createState() =>
      _PlaylistMoreBottomSheetState();
}

class _PlaylistMoreBottomSheetState extends State<PlaylistMoreBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheetSkeleton(
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: HeadlineMediumText.dark(
                  widget.playlist.name,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          buildActionWidget(
            icon: SvgPicture.asset(IconsOutlined.edit),
            text: 'Edit',
            onTap: () => Navigator.of(context).pushReplacement(
              PlaylistEditPage.route(widget.playlist),
            ),
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
                builder: (context) => PlaylistDeleteConfirmationBottomSheet(
                    playlist: widget.playlist),
              )) as PlaylistDeleteConfirmationAction?;

              if (action == PlaylistDeleteConfirmationAction.delete) {
                if (mounted) {
                  await context
                      .read<PlaylistsCubit>()
                      .delete(widget.playlist)
                      .then((value) => Navigator.of(context).pop());
                }
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
