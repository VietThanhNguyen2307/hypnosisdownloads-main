import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class CustomBottomModalSheet {
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) async {
    return showModalBottomSheet(
      context: context,
      builder: builder,
      backgroundColor: ComponentColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      barrierColor: ComponentColors.barrierColor,
      isScrollControlled: true,
      useRootNavigator: true,
    );
  }
}
