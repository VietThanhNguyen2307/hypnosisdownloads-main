import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_bottom_sheet_skeleton.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';

enum PlaylistDeleteConfirmationAction {
  delete,
  cancel,
}

class PlaylistDeleteConfirmationBottomSheet extends StatelessWidget {
  const PlaylistDeleteConfirmationBottomSheet({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheetSkeleton(
      child: Column(
        children: [
          const Row(
            children: [
              Flexible(
                child: HeadlineMediumText.dark(
                  'Are you sure you want to delete this playlist?',
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: BodyMediumText.dark(
                  playlist.name,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            'No, cancel',
            onTap: () => Navigator.of(context)
                .pop(PlaylistDeleteConfirmationAction.cancel),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            'Yes, delete',
            onTap: () {
              Navigator.of(context)
                  .pop(PlaylistDeleteConfirmationAction.delete);
            },
          ),
        ],
      ),
    );
  }
}
