import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/connectivity_status/logic/connectivity_status_cubit.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/view/components/audio_list_view_item.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';

class ScriptListViewItem extends StatelessWidget {
  const ScriptListViewItem({
    Key? key,
    required this.downloadable,
    this.onTap,
    required this.onActionTap,
    required this.onCancel,
  }) : super(key: key);

  final Downloadable<Product> downloadable;
  final VoidCallback? onTap;
  final Function(Downloadable<Product>) onActionTap;
  final Function(Downloadable<Product>) onCancel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityStatusCubit, ConnectivityStatusState>(
      builder: (context, state) {
        final isOnline = state is ConnectivityStatusOnline;
        final isDownloaded =
            downloadable.status == DownloadTaskStatus.complete.index ||
                downloadable.downloadedPercent == 100;
        final isEnabled = isOnline || isDownloaded;
        return GestureDetector(
          onTap: isEnabled
              ? onTap
              : () {
                  if (!isOnline) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please go online to view or download scripts'),
                      ),
                    );
                  }
                },
          child: Opacity(
            opacity: isEnabled ? 1 : 0.75,
            child: SizedBox(
              height: 48,
              child: Center(
                child: Row(
                  children: [
                    // fix icon drawing
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 2,
                        ),
                        SvgPicture.asset(
                          IconsBold.book,
                          color: ComponentColors.secondaryIconColor,
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: BodyMediumText(
                        downloadable.item.name,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    const SizedBox(width: 20),
                    buildActions(
                      context,
                      downloadable,
                      onActionTap: onActionTap,
                      onCancel: onCancel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
