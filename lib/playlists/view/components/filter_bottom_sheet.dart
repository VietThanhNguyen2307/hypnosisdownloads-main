import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/common/filtering_mode.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_bottom_sheet_skeleton.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet(
      {Key? key, this.initialFilter, this.skipFilters = const []})
      : super(key: key);

  final FilteringMode? initialFilter;
  final List<FilteringMode> skipFilters;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  void initState() {
    selectedFilter = widget.initialFilter ?? FilteringMode.none;
    super.initState();
  }

  FilteringMode selectedFilter = FilteringMode.none;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheetSkeleton(
      child: Column(
        children: [
          const Row(
            children: [
              HeadlineMediumText.dark(
                'Sort by',
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Column(
            children: FilteringMode.values
                .where((e) => !widget.skipFilters.contains(e))
                .map(
                  (e) => _FilterButtonEntry(
                    filter: e,
                    active: selectedFilter == e,
                    onTap: () => Navigator.of(context).pop(e),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

class _FilterButtonEntry extends StatelessWidget {
  const _FilterButtonEntry({
    Key? key,
    required this.filter,
    this.active = false,
    this.onTap,
  }) : super(key: key);

  final FilteringMode filter;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyMediumText(
              filter.readable,
              color: active ? ComponentColors.primaryColor : null,
            ),
            if (active)
              SvgPicture.asset(
                IconsOutlined.check,
                color: ComponentColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
