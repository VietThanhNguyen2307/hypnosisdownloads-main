import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/common/filtering_mode.dart';
import 'package:hypnosis_downloads/app/home/routes/sessions_routes.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/common/shadows.dart';
import 'package:hypnosis_downloads/app/view/components/app_cover.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/label_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button_small.dart';
import 'package:hypnosis_downloads/playlists/view/components/filter_bottom_sheet.dart';
import 'package:hypnosis_downloads/library/cubit/sessions_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:provider/provider.dart';

class YourScriptsPackListView extends StatelessWidget {
  const YourScriptsPackListView({Key? key, required this.yourScriptsPacks})
      : super(key: key);

  final List<ProductPack> yourScriptsPacks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const HeadlineMediumText.dark('Your script packs'),
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
                    initialFilter: context.read<SessionsCubit>().filter),
              ).then((value) {
                if (value != null) {
                  context.read<SessionsCubit>().onFilterChanged(value);
                }
              }),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _renderContent(filterPacks(context, yourScriptsPacks)),
      ],
    );
  }

  Widget _renderContent(List<ProductPack> packs) {
    if (packs.isEmpty) {
      return buildEmptyWidget();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ListView.separated(
        itemCount: packs.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (BuildContext context, int index) {
          final pack = packs[index];
          return YourScriptsPackListViewItem(
            yourScriptPack: pack,
            onTap: () => pushPackDetailsPage(
              context,
              pack.type,
              pack,
            ),
          );
        },
      ),
    );
  }

  List<ProductPack> filterPacks(BuildContext context, List<ProductPack> packs) {
    final filter = context.read<SessionsCubit>().filter;
    switch (filter) {
      case FilteringMode.none:
        return packs;
      case FilteringMode.alphabet:
        return packs..sort((a, b) => a.name.compareTo(b.name));
      case FilteringMode.aplhabetReversed:
        return packs..sort((a, b) => b.name.compareTo(a.name));
      case FilteringMode.date:
        return packs..sort((a, b) => b.orderTime.compareTo(a.orderTime));
      case FilteringMode.dateReversed:
        return packs..sort((a, b) => b.orderTime.compareTo(a.orderTime));
    }
  }

  Widget buildEmptyWidget() {
    return const SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BodyMediumText.dark('No script packs yet'),
        ],
      ),
    );
  }
}

class YourScriptsPackListViewItem extends StatelessWidget {
  const YourScriptsPackListViewItem({
    Key? key,
    required this.yourScriptPack,
    this.onTap,
  }) : super(key: key);

  final ProductPack yourScriptPack;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        decoration: BoxDecoration(
          color: ComponentColors.primaryCardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [Shadows.card],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox(
                width: 88,
                height: 64,
                child: AppCover(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BodyMediumText.dark(
                          yourScriptPack.name,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LabelText('${yourScriptPack.products.length} files')
                ],
              ),
            )
          ],
        ),
      ),
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
