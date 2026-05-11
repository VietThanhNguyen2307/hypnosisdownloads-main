import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/home/page_index_provider.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/app_cover.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/products/audios/player/view/components/audio_player.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({
    super.key,
    required this.audioPack,
    required this.playlist,
    required this.currentIndex,
    required this.currentAudio,
  });

  final ProductPack? audioPack;
  final Playlist? playlist;
  final int currentIndex;
  final Product? currentAudio;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          const Spacer(flex: 1),
          Flexible(
            flex: 15,
            child: Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey.shade500,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   height: 4,
                  //   width: 46,
                  // ),
                  const SizedBox(height: 20),
                  buildThumbnails(),
                  const SizedBox(height: 24),

                  if (widget.audioPack != null || widget.playlist != null) ...[
                    SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.currentAudio?.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.currentAudio?.getAlbumName() ?? "",
                                  style: const TextStyle(
                                    color: ComponentColors.subtitleColor,
                                    height: 1.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AudioPlayerWidget(
                      audioPack: widget.audioPack,
                      playlist: widget.playlist,
                      audio: (widget.audioPack != null
                          ? widget.audioPack!.products
                              .elementAt(widget.currentIndex)
                          : widget.playlist!.products
                              .elementAt(widget.currentIndex)),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    const Text(
                      "No audio playing.",
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Provider.of<PageIndexProvider>(context,
                                    listen: false)
                                .setActiveIndex(activeIndex: 0);
                          },
                          child: const Text(
                            "Go to your library",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ComponentColors.primaryColor,
                            ),
                          ),
                        ),
                        const Text(
                          " and choose an audio session.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        Provider.of<PageIndexProvider>(context, listen: false)
                            .setActiveIndex(activeIndex: 0);
                      },
                      child: const Text(
                        "My Library",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ComponentColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildThumbnails() {
    return Container(
      height: 250,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ComponentColors.thumbnailBackgroundColor,
      ),
      child: const AppCover(),
    );
  }

  Widget buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
    );
  }
}
