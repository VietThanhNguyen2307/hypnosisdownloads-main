import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';

class AppLogoWithText extends StatelessWidget {
  const AppLogoWithText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo_with_text',
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 180),
        child: SvgPicture.asset(
          Assets.logoWithText,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
