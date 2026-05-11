import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/playlists/create_playlist/cubit/create_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/view/components/create_new_playlist_view.dart';

class CreateNewPlaylistPage extends StatelessWidget {
  const CreateNewPlaylistPage({Key? key}) : super(key: key);

  static Page<void> get page =>
      const MaterialPage<void>(child: CreateNewPlaylistPage());

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const CreateNewPlaylistPage());

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePlaylistCubit, CreatePlaylistState>(
      listener: (context, state) {
        if (state is CreatePlaylistSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: const CustomLoaderOverlay(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar.secondary(
            title: 'Create new playlist',
            centerTitle: false,
          ),
          body: CreateNewPlaylistView(),
        ),
      ),
    );
  }
}
