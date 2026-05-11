import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static ProductPack? currentPack;
  static Playlist? currentPlaylist;
}
