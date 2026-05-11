import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_text.dart';

class DropdownSettingsListViewItem extends StatelessWidget {
  const DropdownSettingsListViewItem({
    Key? key,
    required this.icon,
    required this.text,
    this.color = ComponentColors.settingsBadgeColor,
    this.onTap,
  }) : super(key: key);

  const DropdownSettingsListViewItem.logout({
    Key? key,
    required this.icon,
    required this.text,
    this.color = ComponentColors.settingsBadgeColorLogout,
    this.onTap,
  }) : super(key: key);

  final String icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTitleWithAction(),
            SvgPicture.asset(Assets.shortArrowRight),
          ],
        ),
      ),
    );
  }

  Widget buildTitleWithAction() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: SvgPicture.asset(icon, color: color),
          ),
        ),
        const SizedBox(width: 12),
        BodyText(text),
      ],
    );
  }
}
