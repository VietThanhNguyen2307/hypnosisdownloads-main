import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';

class DefaultBottomSheetSkeleton extends StatelessWidget {
  const DefaultBottomSheetSkeleton({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  static const _bottomPadding = 8.0;

  // In different devices we don`t have an home button on screen,
  // so we need to calculate that padding by hands
  double calculateBottomPadding(BuildContext context) {
    if (MediaQuery.of(context).padding.bottom <= _bottomPadding) {
      return _bottomPadding;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(16, 16, 16, calculateBottomPadding(context)),
          child: Column(
            children: [
              Row(
                children: [
                  DefaultIconButton(
                    SvgPicture.asset(IconsOutlined.close),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
