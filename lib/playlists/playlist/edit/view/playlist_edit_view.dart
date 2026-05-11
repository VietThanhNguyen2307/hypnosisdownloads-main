import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_input_field.dart';

class PlaylistEditView extends StatelessWidget {
  const PlaylistEditView({Key? key, required this.nameEditingController})
      : super(key: key);

  final TextEditingController nameEditingController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HeadlineText.dark('Name the playlist'),
          const SizedBox(height: 24),
          DefaultInputField(
            hintText: 'Name',
            controller: nameEditingController,
          ),
        ],
      ),
    );
  }
}
