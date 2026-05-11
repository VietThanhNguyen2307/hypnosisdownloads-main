import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DocumentViewerView extends StatelessWidget {
  const DocumentViewerView({Key? key, required this.script}) : super(key: key);

  final Product script;

  onDocumentLoadFailed(BuildContext context) => (details) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Padding(
              padding: const EdgeInsets.all(12),
              child: IntrinsicHeight(
                child: Center(
                  child: Text(
                    details.error,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: ComponentColors.snackBarTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
        Navigator.of(context).pop();
      };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color
      statusBarIconBrightness: Brightness.dark, // Set status bar icons color
    ));
    return FutureBuilder(
        future: useOfflineLinkIfAvailableOrDownloadFromNetwork(context, script),
        builder: (context, builder) {
          if (builder.hasData) {
            final script = builder.data as Product;
            return PDFView(
              filePath: script.link,
            );
          } else {
            return nothing;
          }
        });
  }

  Future<Product> useOfflineLinkIfAvailableOrDownloadFromNetwork(
      BuildContext context, Product product) async {
    final downloadableProductsCubit = context.read<DownloadableProductsCubit>();
    final downloadable =
        await downloadableProductsCubit.getDownloadStatusForSingle(product);
    if (downloadable.status == DownloadTaskStatus.complete.index) {
      return downloadable.item.copyWith(link: downloadable.offlineUrl);
    } else {
      // Download the file
      final downloadedFile = await _downloadFile(product.link);
      return downloadable.item.copyWith(link: downloadedFile.path);
    }
  }

  Future<File> _downloadFile(String link) async {
    // Send a GET request to download the file
    final response = await http.get(Uri.parse(link));

    // Get the temporary directory of the app
    final tempDir = await getTemporaryDirectory();

    // Create a File with a unique name in the temporary directory
    final file = File(path.join(tempDir.path, 'downloaded.pdf'));

    // Write the downloaded bytes to the file
    await file.writeAsBytes(response.bodyBytes);

    // Return the downloaded file
    return file;
  }
}
