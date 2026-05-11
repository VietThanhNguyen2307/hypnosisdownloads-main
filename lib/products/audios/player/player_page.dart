import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/home/page_index_provider.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/player/view/player_view.dart';
import 'package:hypnosis_downloads/products/audios/view/components/audio_more_bottom_sheet.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    Key? key,
    required this.downloadable,
    required this.audioPack,
    required this.playlist,
    this.navigatedByMiniPlayer = false,
  }) : super(key: key);

  final Downloadable<Product>? downloadable;
  final ProductPack? audioPack;
  final Playlist? playlist;
  final bool navigatedByMiniPlayer;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.hypnosisAudioPlayer.hide());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color
      statusBarIconBrightness: Brightness.dark,
    ));
    return WillPopScope(
      onWillPop: () async {
        context.hypnosisAudioPlayer.show();
        return true;
      },
      child: CustomLoaderOverlay(
        opacity: .1,
        child: StreamBuilder(
          stream: context.hypnosisAudioPlayer.currentAudioStream,
          builder: (BuildContext context, AsyncSnapshot<Product?> snapshot) {
            return Scaffold(
              appBar: CustomAppBar.secondary(
                title: 'Back',
                titleClickable: true,
                centerTitle: false,
                onBackButtonPressed: () {
                  context.hypnosisAudioPlayer.show();
                  if (widget.navigatedByMiniPlayer) {
                    Navigator.pop(context);
                  } else {
                    Provider.of<PageIndexProvider>(context, listen: false)
                        .navigateToPreviousTab();
                  }

                  SystemChrome.setSystemUIOverlayStyle(
                      const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent, // Set status bar color
                    statusBarIconBrightness: Brightness.light,
                  ));
                },
                actions: [
                  if (widget.downloadable != null &&
                      !widget.downloadable!.item.isQuickBreaks())
                    DefaultIconButton(
                      SvgPicture.asset(IconsBold.more),
                      onTap: () => CustomBottomModalSheet.showBottomSheet.call(
                        context: context,
                        builder: (context) => AudioMoreBottomSheet(
                          downloadable: widget.downloadable!,
                          onActionTap: (downloadable) => context
                              .read<DownloadableProductsCubit>()
                              .delete(downloadable),
                        ),
                      ),
                    ),
                ],
              ),
              body: PlayerView(
                currentAudio: context.hypnosisAudioPlayer.currentAudio,
                audioPack: widget.audioPack,
                playlist: widget.playlist,
                currentIndex: widget.downloadable != null
                    ? widget.audioPack != null
                        ? widget.audioPack!.products
                            .indexOf(widget.downloadable!.item)
                        : widget.playlist!.products
                            .indexOf(widget.downloadable!.item)
                    : 0,
              ),
              bottomNavigationBar: const SizedBox(),
            );
          },
        ),
      ),
    );
  }
}
