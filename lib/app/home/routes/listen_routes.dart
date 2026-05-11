import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/home/page_index_provider.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/products/audios/download/data/model/downloadable.dart';
import 'package:hypnosis_downloads/products/audios/player/player_page.dart';
import 'package:hypnosis_downloads/products/audios/player/player_page_wrapper.dart';
import 'package:hypnosis_downloads/products/scripts/document_viewer/document_viewer_page.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:provider/provider.dart';

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

const String productPageRouteName = '_product_page_route_name';

Route<dynamic>? onGenerateListenRoute(RouteSettings settings) {
  return PlayerPageWrapper.route;
}

void pushPlayerPage(
  BuildContext context,
  DownloadProductType type,
  Downloadable<Product> downloadable,
  ProductPack? productPack,
  Playlist? playlist, {
  bool navigatedByMiniPlayer = false,
}) {
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
        navigatedByMiniPlayer: navigatedByMiniPlayer,
      );
    }));
    if (!navigatedByMiniPlayer) {
      Provider.of<PageIndexProvider>(context, listen: false)
          .navigateToListenTab();
    }
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DocumentViewerPage(
        script: downloadable.item,
      );
    }));
  }
}
