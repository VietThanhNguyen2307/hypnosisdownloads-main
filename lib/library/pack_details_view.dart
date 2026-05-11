import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/app/view/components/app_cover.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/components/play_button.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/label_text.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/view/products_list_view.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:just_audio/just_audio.dart';

class PackDetailsView extends StatefulWidget {
  const PackDetailsView({Key? key, required this.packDetails})
      : super(key: key);

  final ProductPack packDetails;

  @override
  State<PackDetailsView> createState() => _PackDetailsViewState();
}

class _PackDetailsViewState extends State<PackDetailsView> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color
      statusBarIconBrightness: Brightness.dark, // Set status bar icons color
    ));
    return CustomLoaderOverlay(
      opacity: .1,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 150),
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const SizedBox(
                              width: 88,
                              height: 64,
                              child: AppCover(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: HeadlineMediumText.dark(
                                  widget.packDetails.name,
                                ),
                              ),
                            ],
                          ),
                          LabelText(
                            '${widget.packDetails.products.length} files',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              StreamBuilder(
                stream: context.hypnosisAudioPlayer.playerStateStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<PlayerState> playerStateSnapshot,
                ) {
                  final playerState = playerStateSnapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing == true;
                  final buffering =
                      processingState == ProcessingState.buffering;
                  final loading = processingState == ProcessingState.loading;

                  if (loading || buffering) {
                    return const CustomLoadingIndicator(size: 48);
                  }

                  final isCurrentPack =
                      context.hypnosisAudioPlayer.audioSource?.id ==
                          widget.packDetails.id;

                  if (isCurrentPack && !(loading || buffering)) {
                    context.hypnosisAudioPlayer.show();
                  }
                  return PlayButton(
                    playing: playing && isCurrentPack,
                    onTap: () async {
                      NavigationService.currentPack = widget.packDetails;
                      if (isCurrentPack) {
                        if (playing) {
                          await context.hypnosisAudioPlayer.pause();
                        } else {
                          await context.hypnosisAudioPlayer.play();
                        }
                      } else {
                        await _setCurrentPlaylist();
                      }

                      context.hypnosisAudioPlayer.show();
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              ProductsListView(
                pack: widget.packDetails,
                playlist: null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setCurrentPlaylist() async {
    await context.hypnosisAudioPlayer.setPackAudioSource(
      widget.packDetails,
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
