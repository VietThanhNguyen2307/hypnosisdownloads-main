import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypnosis_downloads/playlists/view/components/playlists_app_bar.dart';
import 'package:hypnosis_downloads/playlists/view/playlists_view.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({Key? key}) : super(key: key);

  static Page<void> get page =>
      const MaterialPage<void>(child: PlaylistsPage());

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const PlaylistsPage());

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: PlaylistsAppBar(),
        body: SafeArea(child: PlaylistsView()),
        bottomNavigationBar: SizedBox(),
      ),
    );
  }
}
