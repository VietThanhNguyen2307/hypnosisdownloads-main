import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/player/player_page.dart';
import 'package:hypnosis_downloads/products/scripts/document_viewer/document_viewer_page.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:hypnosis_downloads/library/pack_details_page.dart';
import 'package:hypnosis_downloads/library/library_page.dart';

class PackDetailPageArguments {
  PackDetailPageArguments(this.type, this.pack);

  final DownloadProductType type;
  final ProductPack pack;
}

class ProductPageArgumnets {
  ProductPageArgumnets({
    required this.type,
    required this.downloadable,
    required this.productPack,
    required this.playlist,
  });

  final DownloadProductType type;
  final Downloadable<Product> downloadable;
  final ProductPack? productPack;
  final Playlist? playlist;
}

const String packDetailsRouteName = '_pack_details_page_route_name';
const String productPageRouteName = '_product_page_route_name';

Route<dynamic>? onGenerateLibraryRoute(RouteSettings settings) {
  Widget page = const LibraryPage();

  final routeName = settings.name;
  final routeSettings = settings.arguments;

  if (routeName == packDetailsRouteName && routeSettings != null) {
    final args = routeSettings as PackDetailPageArguments;

    switch (args.type) {
      case DownloadProductType.audio:
      case DownloadProductType.script:
      case DownloadProductType.audioWithScript:
        page = PackDetailsPage(
          packDetails: args.pack,
        );
        break;
    }
  } else if (routeName == productPageRouteName && routeSettings != null) {
    final args = routeSettings as ProductPageArgumnets;

    switch (args.type) {
      case DownloadProductType.audio:
        page = PlayerPage(
          downloadable: args.downloadable,
          playlist: args.playlist,
          audioPack: args.productPack,
        );
        break;
      case DownloadProductType.script:
        page = DocumentViewerPage(
          script: args.downloadable.item,
        );
        break;
      case DownloadProductType.audioWithScript:
        break;
    }
  }
  return MaterialPageRoute(builder: (_) => page);
}

void pushPackDetailsPage(
  BuildContext context,
  DownloadProductType type,
  ProductPack pack,
) {
  Navigator.pushNamed(
    context,
    packDetailsRouteName,
    arguments: PackDetailPageArguments(type, pack),
  );
}

void pushProductPage(
  BuildContext context,
  DownloadProductType type,
  Downloadable<Product> downloadable,
  ProductPack? productPack,
  Playlist? playlist,
) {
  if (productPack != null) {
    NavigationService.currentPack = productPack;
    NavigationService.currentPlaylist = null;
  }
  if (playlist != null) {
    NavigationService.currentPlaylist = playlist;
    NavigationService.currentPack = null;
  }
  if (type == DownloadProductType.audio) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return PlayerPage(
        downloadable: downloadable,
        audioPack: productPack,
        playlist: playlist,
      );
    }));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DocumentViewerPage(
        script: downloadable.item,
      );
    }));
  }
}
