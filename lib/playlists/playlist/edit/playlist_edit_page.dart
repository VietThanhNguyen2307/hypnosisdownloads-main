import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/components/successful_snackbar.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/edit/cubit/edit_playlist_name_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/edit/view/playlist_edit_view.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PlaylistEditPage extends StatefulWidget {
  const PlaylistEditPage({Key? key, required this.playlist}) : super(key: key);

  final Playlist playlist;

  static Page<void> page(Playlist playlist) => MaterialPage<void>(
        child: PlaylistEditPage(
          playlist: playlist,
        ),
      );

  static MaterialPageRoute<dynamic> route(Playlist playlist) =>
      MaterialPageRoute(
        builder: (context) => PlaylistEditPage(playlist: playlist),
      );

  @override
  State<PlaylistEditPage> createState() => _PlaylistEditPageState();
}

class _PlaylistEditPageState extends State<PlaylistEditPage> {
  /// Maybe we can use BLoC insted of this, but when i`m thinking about it,
  /// i know that state will bee saved and we must clear state every time
  /// when open that page

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditPlaylistNameCubit, EditPlaylistNameState>(
      listener: (context, state) {
        if (state is SaveNameSuccess) {
          Navigator.of(context).pop();
          SuccessfulSnackbar.show(
            context,
            'Playlist name was changed',
          );
        }

        if (state is SaveNameFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }

        if (state is SaveNameInProgress) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
      child: CustomLoaderOverlay(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar.secondary(
            title: 'Edit playlist',
            centerTitle: false,
            actions: [
              DefaultTextButton(
                'Save',
                onPressed: () => context.read<EditPlaylistNameCubit>().saveName(
                      _textController.text,
                      widget.playlist,
                    ),
              ),
            ],
          ),
          body: PlaylistEditView(nameEditingController: _textController),
        ),
      ),
    );
  }
}
