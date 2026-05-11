import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/common/filtering_mode.dart';
import 'package:hypnosis_downloads/app/home/routes/listen_routes.dart';
import 'package:hypnosis_downloads/app/home/routes/sessions_routes.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_switch.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button_small.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/view/components/filter_bottom_sheet.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/view/components/audio_list_view_item.dart';
import 'package:hypnosis_downloads/products/scripts/view/components/script_list_view_item.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:hypnosis_downloads/library/view/components/download_bottom_sheet.dart';

class ProductsListView extends StatefulWidget {
  const ProductsListView({
    required this.pack,
    required this.playlist,
    super.key,
  });

  final ProductPack? pack;
  final Playlist? playlist;

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  @override
  void initState() {
    if (widget.pack != null) {
      print('tagx - This pack got ${widget.pack!.products.length} products');
    } else if (widget.playlist != null) {
      print(
          'tagx - This playlist got ${widget.playlist!.products.length} products');
    }
    unawaited(context.read<DownloadableProductsCubit>().onPageOpened(
        widget.pack != null
            ? widget.pack!.products
            : widget.playlist!.products));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadableProductsCubit, DownloadableProductsState>(
      builder: (context, state) {
        if (state is DownloadableProductsLoadSuccess) {
          final downloadableProducts = state.downloadableProducts;
          print(
              'tagx - We have downloaded ${downloadableProducts.where((element) => element.status == DownloadTaskStatus.complete.index).length} products');
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const HeadlineMediumText.dark('Download'),
                  const Spacer(),
                  DefaultTextButtonSmall.icon(
                    'Sort by',
                    icon: SvgPicture.asset(
                      IconsOutlined.sort,
                      color: ComponentColors.defaultIconColor,
                    ),
                    onPressed: () =>
                        CustomBottomModalSheet.showBottomSheet<FilteringMode?>(
                      context: context,
                      builder: (context) => FilterBottomSheet(
                        initialFilter:
                            context.read<DownloadableProductsCubit>().filter,
                        skipFilters: const [
                          FilteringMode.date,
                          FilteringMode.dateReversed,
                        ],
                      ),
                    ).then((value) {
                      if (value != null) {
                        context
                            .read<DownloadableProductsCubit>()
                            .applyFilter(value);
                      }
                    }),
                  ),
                  const SizedBox(width: 8),
                  DefaultSwitch.small(
                    value: context
                        .read<DownloadableProductsCubit>()
                        .areSomeProductsDownloaded(),
                    onToggle: (isChecked) {
                      if (isChecked) {
                        CustomBottomModalSheet.showBottomSheet.call(
                          context: context,
                          builder: (context) => DownloadBottomSheet(
                            onConfirm: () {
                              context
                                  .read<DownloadableProductsCubit>()
                                  .onBulkActionTap();
                              Navigator.of(context).pop();
                            },
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                        );
                      } else {
                        context
                            .read<DownloadableProductsCubit>()
                            .onBulkActionTap();
                      }
                    },
                  ),
                ],
              ),
              _renderContent(_filterProducts(downloadableProducts)),
            ],
          );
        } else {
          return nothing;
        }
      },
    );
  }

  List<Downloadable<Product>> _filterProducts(
      List<Downloadable<Product>> downloadableProducts) {
    final filter = context.read<DownloadableProductsCubit>().filter;
    switch (filter) {
      case FilteringMode.alphabet:
        return downloadableProducts
          ..sort((a, b) => a.item.name.compareTo(b.item.name));
      case FilteringMode.aplhabetReversed:
        return downloadableProducts
          ..sort((a, b) => b.item.name.compareTo(a.item.name));
      default:
        return downloadableProducts;
    }
  }

  Widget _renderContent(List<Downloadable<Product>> downloadableProducts) {
    return ListView.builder(
      itemCount: downloadableProducts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        final downloadableProduct = downloadableProducts[index];

        if (downloadableProduct.item.type == DownloadProductType.audio) {
          return AudioListViewItem(
            downloadable: downloadableProduct,
            onTap: () => pushPlayerPage(
              context,
              DownloadProductType.audio,
              downloadableProduct,
              widget.pack,
              widget.playlist,
            ),
            onActionTap: (downloadable) => context
                .read<DownloadableProductsCubit>()
                .onActionTap(downloadable),
            onCancel: (downloadable) => context
                .read<DownloadableProductsCubit>()
                .onCancel(downloadable),
            playlist: widget.playlist,
          );
        } else {
          return ScriptListViewItem(
            downloadable: downloadableProduct,
            onTap: () => pushProductPage(
              context,
              DownloadProductType.script,
              downloadableProduct,
              widget.pack,
              widget.playlist,
            ),
            onActionTap: (downloadable) => context
                .read<DownloadableProductsCubit>()
                .onActionTap(downloadable),
            onCancel: (downloadable) => context
                .read<DownloadableProductsCubit>()
                .onCancel(downloadable),
          );
        }
      },
    );
  }
}
