import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/player/player_page.dart';

class PlayerPageWrapper extends StatelessWidget {
  const PlayerPageWrapper({super.key});

  static MaterialPageRoute<dynamic> get route => MaterialPageRoute(
        builder: (context) => const PlayerPageWrapper(),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.hypnosisAudioPlayer.currentAudioStream,
        builder: (context, snapshot) {
          final currentAudio = NavigationService
              .navigatorKey.currentContext!.hypnosisAudioPlayer.currentAudio;
          final currentPack = NavigationService.currentPack;
          final currentPlaylist = NavigationService.currentPlaylist;
          return PlayerPage(
            downloadable: currentAudio == null
                ? null
                : Downloadable(
                    item: currentAudio,
                    name: currentAudio.filename,
                    onlineUrl: currentAudio.link,
                  ),
            audioPack: currentPack,
            playlist: currentPlaylist,
          );
        });
  }
}
