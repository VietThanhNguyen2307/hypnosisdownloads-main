import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';

class SuccessfulSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SvgPicture.asset(
                IconsOutlined.check,
                width: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: BodyMediumText.white(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
          backgroundColor: ComponentColors.primaryColor,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
  }
}
