import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_bottom_sheet_skeleton.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';

enum DeleteConfirmationAction {
  delete,
  cancel,
}

class DeleteConfirmationBottomSheet extends StatelessWidget {
  const DeleteConfirmationBottomSheet({
    Key? key,
    required this.downloadable,
  }) : super(key: key);

  final Downloadable<Product> downloadable;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheetSkeleton(
      child: Column(
        children: [
          const Row(
            children: [
              Flexible(
                child: HeadlineMediumText.dark(
                  'Are you sure you want to delete this file?',
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: BodyMediumText.dark(
                  downloadable.item.name,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            'No, cancel',
            onTap: () =>
                Navigator.of(context).pop(DeleteConfirmationAction.cancel),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            'Yes, delete',
            onTap: () {
              Navigator.of(context).pop(DeleteConfirmationAction.delete);
            },
          ),
        ],
      ),
    );
  }
}
