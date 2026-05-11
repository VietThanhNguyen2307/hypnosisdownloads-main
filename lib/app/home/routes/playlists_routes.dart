import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/app/home/routes/sessions_routes.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/playlist_page.dart';
import 'package:hypnosis_downloads/playlists/view/components/create_new_playlist_page.dart';
import 'package:hypnosis_downloads/playlists/view/playlists_page.dart';
import 'package:hypnosis_downloads/products/audios/player/player_page.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';

class PlaylistPageArguments {
  PlaylistPageArguments(this.playlist);

  final Playlist playlist;
}

const createNewPlaylistPageRouteName = '_create_new_playlist_page_route_name';
const playlistPageRouteName = '_playlist_page_route_name';
const playlistDeletedRouteName = '_playlist_deleted_route_name';
const playlistNameChangedRouteName = '_playlist_name_changed_route_name';
const productPageRouteName = '_product_page_route_name';

Route<dynamic>? onGeneratePlaylistsRoute(RouteSettings settings) {
  Widget page = const PlaylistsPage();

  final routeName = settings.name;
  final routeSettings = settings.arguments;

  if (routeName == createNewPlaylistPageRouteName) {
    page = const CreateNewPlaylistPage();
  } else if (routeName == playlistPageRouteName && routeSettings != null) {
    final args = routeSettings as PlaylistPageArguments;
    page = PlaylistPage(initialPlaylist: args.playlist);
  } else if (routeName == playlistDeletedRouteName ||
      routeName == playlistNameChangedRouteName) {
    page = const PlaylistsPage();
  } else if (routeName == productPageRouteName && routeSettings != null) {
    final args = routeSettings as ProductPageArgumnets;

    switch (args.type) {
      case DownloadProductType.audio:
        page = PlayerPage(
          downloadable: args.downloadable,
          audioPack: null,
          playlist: args.playlist,
        );
        break;
      case DownloadProductType.script:
        break;
      case DownloadProductType.audioWithScript:
        break;
    }
  }
  return MaterialPageRoute(builder: (_) => page);
}

void pushCreateNewPlaylistPage(BuildContext context) {
  Navigator.of(context).pushNamed(createNewPlaylistPageRouteName);
}

void pushPlaylistPage(BuildContext context, Playlist playlist) {
  NavigationService.currentPlaylist = playlist;
  Navigator.of(context).pushNamed(
    playlistPageRouteName,
    arguments: PlaylistPageArguments(playlist),
  );
}
