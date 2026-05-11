import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/common/filtering_mode.dart';
import 'package:hypnosis_downloads/app/home/routes/listen_routes.dart';
import 'package:hypnosis_downloads/app/home/routes/sessions_routes.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button_small.dart';
import 'package:hypnosis_downloads/playlists/view/components/filter_bottom_sheet.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/recent_downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/view/components/audio_list_view_item.dart';
import 'package:hypnosis_downloads/products/scripts/view/components/script_list_view_item.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';

class RecentProductsSection extends StatefulWidget {
  const RecentProductsSection({
    Key? key,
    required this.pack,
  }) : super(key: key);

  final ProductPack pack;

  @override
  State<RecentProductsSection> createState() => _RecentProductsSectionState();
}

class _RecentProductsSectionState extends State<RecentProductsSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentDownloadableProductsCubit,
        DownloadableProductsState>(
      builder: (context, state) {
        if (state is DownloadableProductsLoadSuccess) {
          final downloadableProducts = state.downloadableProducts
              .where((product) => product.item.type == widget.pack.type)
              .toList();

          final recentProducts = downloadableProducts
              .take(expanded ? downloadableProducts.length : 3)
              .toList();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeadlineMediumText.dark(
                    widget.pack.type == DownloadProductType.audio
                        ? 'Recent audios'
                        : 'Recent scripts',
                  ),
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
                        initialFilter: context
                            .read<RecentDownloadableProductsCubit>()
                            .filter,
                      ),
                    ).then((value) {
                      if (value != null) {
                        context
                            .read<RecentDownloadableProductsCubit>()
                            .applyFilter(value);
                      }
                    }),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    child: DefaultTextButton(
                      key: ValueKey(expanded),
                      !expanded ? 'View all' : 'View less',
                      onPressed: () => setState(() {
                        expanded = !expanded;
                      }),
                    ),
                  )
                ],
              ),
              _renderContent(_filterProducts(context, recentProducts)),
            ],
          );
        } else {
          return nothing;
        }
      },
    );
  }

  Widget _renderContent(List<Downloadable<Product>> recentProducts) {
    if (recentProducts.isEmpty) {
      return buildEmptyWidget();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: ListView.builder(
        key: ValueKey(expanded),
        itemCount: recentProducts.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final downloadable = recentProducts[index];
          if (downloadable.item.type == DownloadProductType.audio) {
            return AudioListViewItem(
              downloadable: downloadable,
              onTap: () => pushPlayerPage(
                context,
                DownloadProductType.audio,
                downloadable,
                widget.pack,
                null,
              ),
              onActionTap: (downloadable) => context
                  .read<RecentDownloadableProductsCubit>()
                  .onActionTap(downloadable),
              onCancel: (downloadable) => context
                  .read<RecentDownloadableProductsCubit>()
                  .onCancel(downloadable),
            );
          } else {
            return ScriptListViewItem(
              downloadable: downloadable,
              onTap: () => pushProductPage(
                context,
                DownloadProductType.script,
                downloadable,
                widget.pack,
                null,
              ),
              onActionTap: (downloadable) => context
                  .read<RecentDownloadableProductsCubit>()
                  .onActionTap(downloadable),
              onCancel: (downloadable) => context
                  .read<RecentDownloadableProductsCubit>()
                  .onCancel(downloadable),
            );
          }
        },
      ),
    );
  }

  List<Downloadable<Product>> _filterProducts(
      BuildContext context, List<Downloadable<Product>> recentProducts) {
    final filter = context.read<RecentDownloadableProductsCubit>().filter;
    switch (filter) {
      case FilteringMode.alphabet:
        return recentProducts
          ..sort((a, b) => a.item.name.compareTo(b.item.name));
      case FilteringMode.aplhabetReversed:
        return recentProducts
          ..sort((a, b) => b.item.name.compareTo(a.item.name));
      case FilteringMode.date:
        return recentProducts
          ..sort((a, b) => a.item.orderTime.compareTo(b.item.orderTime));
      case FilteringMode.dateReversed:
        return recentProducts
          ..sort((a, b) => b.item.orderTime.compareTo(a.item.orderTime));
      default:
        return recentProducts;
    }
  }

  Widget buildEmptyWidget() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BodyMediumText.dark(widget.pack.type == DownloadProductType.audio
              ? 'No audios yet'
              : 'No scripts yet'),
        ],
      ),
    );
  }
}
