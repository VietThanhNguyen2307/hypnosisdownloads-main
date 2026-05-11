import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/home/routes/playlists_routes.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';

class EmptyPlaylistsView extends StatelessWidget {
  const EmptyPlaylistsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: .5,
              child: SizedBox.square(
                dimension: 120,
                child: SvgPicture.asset(
                  IconsBold.music,
                  color: ComponentColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const HeadlineText.dark('No playlists'),
            const SizedBox(height: 8),
            const BodyMediumText('You have not created a playlist yet'),
            const SizedBox(height: 24),
            PrimaryButton(
              'Create',
              onTap: () => pushCreateNewPlaylistPage(context),
            ),
            const SizedBox(
              height: 120,
            )
          ],
        ),
      ),
    );
  }
}
