import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/pack_details_view.dart';
import 'package:hypnosis_downloads/library/view/components/download_bottom_sheet.dart';

class PackDetailsPage extends StatefulWidget {
  const PackDetailsPage({
    required this.packDetails,
    Key? key,
  }) : super(key: key);
  static Page<void> page(ProductPack packDetails) => MaterialPage<void>(
        child: PackDetailsPage(
          packDetails: packDetails,
        ),
      );

  static MaterialPageRoute<dynamic> route(ProductPack packDetails) =>
      MaterialPageRoute(
        builder: (context) => PackDetailsPage(
          packDetails: packDetails,
        ),
      );

  final ProductPack packDetails;

  @override
  State<PackDetailsPage> createState() => _PackDetailsPageState();
}

class _PackDetailsPageState extends State<PackDetailsPage> {
  @override
  void initState() {
    unawaited(context
        .read<DownloadableProductsCubit>()
        .onPageOpened(widget.packDetails.products));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadableProductsCubit, DownloadableProductsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar.secondary(
            title: widget.packDetails.name,
            actions: (state is DownloadableProductsLoadSuccess)
                ? [
                    !context
                            .read<DownloadableProductsCubit>()
                            .areAllProductsDownloaded()
                        ? DefaultIconButton(
                            key: const Key('Download all'),
                            SvgPicture.asset(IconsOutlined.download),
                            onTap: () =>
                                CustomBottomModalSheet.showBottomSheet.call(
                              context: context,
                              builder: (context) => DownloadBottomSheet(
                                onConfirm: () {
                                  context
                                      .read<DownloadableProductsCubit>()
                                      .onDownloadAllProductsTap();
                                  Navigator.of(context).pop();
                                },
                                onCancel: () => Navigator.of(context).pop(),
                              ),
                            ),
                          )
                        : const SizedBox(width: 24),
                  ]
                : [],
            onBackButtonPressed: () {
              Navigator.of(context).pop();
              SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent, // Set status bar color
                statusBarIconBrightness: Brightness.light,
              ));
            },
          ),
          body: PackDetailsView(packDetails: widget.packDetails),
          bottomNavigationBar: const SizedBox(),
        );
      },
    );
  }
}
