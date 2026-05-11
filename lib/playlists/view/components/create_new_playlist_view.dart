import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_input_field.dart';
import 'package:hypnosis_downloads/playlists/create_playlist/cubit/create_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:provider/provider.dart';

class CreateNewPlaylistView extends StatelessWidget {
  const CreateNewPlaylistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: CreatePlaylistForm(),
      ),
    );
  }
}

class CreatePlaylistForm extends StatefulWidget {
  const CreatePlaylistForm({Key? key}) : super(key: key);

  @override
  State<CreatePlaylistForm> createState() => _CreatePlaylistFormState();
}

class _CreatePlaylistFormState extends State<CreatePlaylistForm> {
  final _controller = TextEditingController();

  bool isEmpty = true;

  @override
  void initState() {
    _controller.addListener(() {
      if (isEmpty != _controller.text.isEmpty) {
        setState(() {
          isEmpty = _controller.text.isEmpty;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HeadlineText.dark('Name the playlist'),
        const SizedBox(height: 24),
        DefaultInputField(
          controller: _controller,
          hintText: 'My new playlist',
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                'Cancel',
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: PrimaryButton(
                isEmpty ? 'Skip' : 'Create',
                onTap: () async {
                  await context
                      .read<CreatePlaylistCubit>()
                      .onCreatePlaylist(
                        _controller.text,
                      )
                      .then((value) async =>
                          await context.read<PlaylistsCubit>().onPageOpened());
                },
                // onTap: () => context
                //     .read<CreatePlaylistCubit>()
                //     .onCreatePlaylist(
                //       _controller.text,
                //     )
                //     .then((value) =>
                //         context.read<PlaylistsCubit>().loadPlaylists()),
              ),
            ),
          ],
        )
      ],
    );
  }
}
