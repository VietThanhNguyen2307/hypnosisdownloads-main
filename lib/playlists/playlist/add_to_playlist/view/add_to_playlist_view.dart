import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/add_to_playlist/cubit/cubit/add_to_playlist_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';

class AddToPlaylistView extends StatelessWidget {
  const AddToPlaylistView({
    Key? key,
    required this.playlist,
    required this.packs,
    this.onIndexChanged,
  }) : super(key: key);

  final Playlist playlist;
  final List<ProductPack> packs;
  final ValueChanged<int>? onIndexChanged;

  @override
  Widget build(BuildContext context) {
    if (packs.isEmpty) {
      return const Center(
        child: BodyMediumText.dark('No audios to add'),
      );
    } else {
      return buildContent(packs);
    }
  }

  Widget buildContent(List<ProductPack> productsPacks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CarouselSlider.builder(
        itemCount: productsPacks.length,
        itemBuilder: (context, index, realIndex) {
          final productpack = productsPacks[index];

          return Padding(
            padding: EdgeInsets.only(left: index != 0 ? 12 : 0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: HeadlineMediumText.dark(
                            productpack.name,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: productpack.products.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final product = productpack.products[index];

                          if (product.type == DownloadProductType.audio) {
                            return AddToPlaylistListViewItem(
                              audio: product,
                              playlist: playlist,
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        options: CarouselOptions(
          aspectRatio: 1 / 2,
          enableInfiniteScroll: false,
          viewportFraction: .9,
          clipBehavior: Clip.none,
          onPageChanged: (index, reason) {
            if (onIndexChanged != null) {
              onIndexChanged?.call(index);
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CustomLoadingIndicator(),
    );
  }
}

class AddToPlaylistListViewItem extends StatefulWidget {
  const AddToPlaylistListViewItem({
    Key? key,
    required this.audio,
    this.onTap,
    required this.playlist,
  }) : super(key: key);

  final Product audio;
  final Playlist playlist;
  final VoidCallback? onTap;

  @override
  State<AddToPlaylistListViewItem> createState() =>
      _AddToPlaylistListViewItemState();
}

class _AddToPlaylistListViewItemState extends State<AddToPlaylistListViewItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: BodyMediumText(
                  widget.audio.name,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              const SizedBox(width: 20),
              BlocBuilder<AddToPlaylistCubit, AddToPlaylistState>(
                builder: (context, state) {
                  bool isLoading = state is AddToPlaylistInProgress &&
                      state.audio.id == widget.audio.id;

                  return ValueListenableBuilder(
                    valueListenable:
                        Hive.box<Playlist>('playlists').listenable(),
                    builder: (context, Box<Playlist> box, _) {
                      final playlist =
                          box.get(widget.playlist.id) ?? widget.playlist;
                      bool isAlreadyAdded = playlist.products
                          .map((e) => e.id)
                          .contains(widget.audio.id);

                      if (isAlreadyAdded) {
                        return SvgPicture.asset(
                          IconsOutlined.check,
                          color: ComponentColors.primaryColor,
                        );
                      }
                      return isLoading && !isAlreadyAdded
                          ? const CustomLoadingIndicator(size: 24)
                          : AbsorbPointer(
                              absorbing: isAlreadyAdded,
                              child: DefaultIconButton(
                                SvgPicture.asset(IconsOutlined.add),
                                onTap: () {
                                  context
                                      .read<AddToPlaylistCubit>()
                                      .addToPlaylist(
                                        widget.audio,
                                        playlist,
                                      );

                                  context.read<PlaylistsCubit>().onPageOpened();
                                },
                              ),
                            );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
