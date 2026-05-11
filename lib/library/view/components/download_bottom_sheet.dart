import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_bottom_sheet_skeleton.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';

class DownloadBottomSheet extends StatelessWidget {
  const DownloadBottomSheet({
    required this.onConfirm,
    required this.onCancel,
    Key? key,
  }) : super(key: key);

  final void Function() onConfirm;
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheetSkeleton(
      child: Column(
        children: [
          const Row(
            children: [
              Flexible(
                child: HeadlineMediumText.dark(
                  'Do you want to download all files?',
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            'No',
            onTap: onCancel,
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            'Yes',
            onTap: onConfirm,
          ),
        ],
      ),
    );
  }
}
