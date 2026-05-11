import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/scripts/document_viewer/view/document_viewer_view.dart';
import 'package:hypnosis_downloads/products/scripts/view/components/script_more_bottom_sheet.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';

class DocumentViewerPage extends StatelessWidget {
  const DocumentViewerPage({
    Key? key,
    required this.script,
  }) : super(key: key);
  static Page<void> page(Product audio) => MaterialPage<void>(
        child: DocumentViewerPage(
          script: audio,
        ),
      );

  static MaterialPageRoute<dynamic> route(Product audio) => MaterialPageRoute(
        builder: (context) => DocumentViewerPage(
          script: audio,
        ),
      );

  final Product script;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.secondary(
        title: script.name,
        actions: [
          DefaultIconButton(
            SvgPicture.asset(IconsBold.more),
            onTap: () => CustomBottomModalSheet.showBottomSheet.call(
              context: context,
              builder: (context) => ScriptMoreBottomSheet(
                downloadable: Downloadable(
                  item: script,
                  name: script.filename,
                  onlineUrl: script.link,
                ),
                onActionTap: (downloadable) => context
                    .read<DownloadableProductsCubit>()
                    .onActionTap(downloadable),
              ),
            ),
          ),
        ],
        onBackButtonPressed: () {
          Navigator.of(context).pop();
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ));
        },
      ),
      body: DocumentViewerView(script: script),
      bottomNavigationBar: const SizedBox(),
    );
  }
}
