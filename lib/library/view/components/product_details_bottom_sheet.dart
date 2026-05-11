import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_bottom_sheet_skeleton.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:intl/intl.dart';

class ProductDetailsBottomSheet extends StatelessWidget {
  const ProductDetailsBottomSheet({Key? key, required this.product})
      : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheetSkeleton(
      child: Column(
        children: [
          const Row(
            children: [
              Flexible(
                child: HeadlineMediumText.dark(
                  'Details',
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          buildDetailsListView(
            {
              'Name:': product.name,
              'Downloaded:': 'No',
              'File name:': product.filename,
              'File size:': '--:--',
              'Duration:': '--:--',
              'Path:': '/Internal Storage/HypnosisDownloads/',
              'Last updated:': DateFormat.yMd().format(product.orderTime),
            },
          ),
        ],
      ),
    );
  }

  Widget buildDetailsListView(Map<String, String> details) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        details.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              SizedBox(
                width: 90,
                child: BodyMediumText.light(
                  details.keys.elementAt(index),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BodyMediumText(
                  details.values.elementAt(index),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
