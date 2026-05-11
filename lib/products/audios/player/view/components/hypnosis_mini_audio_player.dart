import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/home/page_index_provider.dart';
import 'package:hypnosis_downloads/app/home/routes/listen_routes.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/components/play_button.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class HypnosisMiniAudioPlayer extends StatelessWidget {
  const HypnosisMiniAudioPlayer({
    required this.navigatorKey,
    super.key,
  });

  final GlobalKey navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Selector(
      selector: (context, provider) =>
          Provider.of<PageIndexProvider>(context).activeIndex,
      builder: ((context, value, child) {
        if (value == 1) return const SizedBox.shrink();
        return InkWell(
          onTap: () {
            final currentAudio = context.hypnosisAudioPlayer.currentAudio!;
            final currentPack = NavigationService.currentPack;
            final currentPlaylist = NavigationService.currentPlaylist;

            pushPlayerPage(
              context,
              DownloadProductType.audio,
              Downloadable(
                item: currentAudio,
                name: currentAudio.filename,
                onlineUrl: currentAudio.link,
              ),
              currentPack,
              currentPlaylist,
              navigatedByMiniPlayer: true,
            );
          },
          child: Container(
            height: 132,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF45AE9E),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      IconsBold.headphone,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    const SizedBox(width: 4),
                    StreamBuilder(
                      stream: context.hypnosisAudioPlayer.currentAudioStream,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<Product?> currentAudioSnapshot,
                      ) {
                        return Expanded(
                          child: BodyMediumText.white(
                            context.hypnosisAudioPlayer.currentAudio?.name ??
                                '',
                            maxLines: 1,
                            softWrap: false,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: context.hypnosisAudioPlayer.playerStateStream,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<PlayerState> playerStateSnapshot,
                      ) {
                        final playing = context.hypnosisAudioPlayer.playing;
                        return SmallPlayButton(
                          playing: playing,
                          onTap: () {
                            if (playing) {
                              context.hypnosisAudioPlayer.pause();
                            } else {
                              context.hypnosisAudioPlayer.play();
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
