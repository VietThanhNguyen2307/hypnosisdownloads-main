import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/connectivity_status/logic/connectivity_status_cubit.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWrapper extends StatefulWidget {
  const AudioPlayerWrapper({
    Key? key,
    required this.child,
    this.playerWidget,
  }) : super(key: key);

  final Widget child;
  final Widget? playerWidget;

  @override
  State<AudioPlayerWrapper> createState() => _AudioPlayerWrapperState();
}

class _AudioPlayerWrapperState extends State<AudioPlayerWrapper> with AutomaticKeepAliveClientMixin {
  AudioPlayerControllerWidget? _hypnosisAudioPlayerController;

  @override
  void initState() {
    setState(() {
      _hypnosisAudioPlayerController = AudioPlayerControllerWidget.of(context);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _hypnosisAudioPlayerController = AudioPlayerControllerWidget.of(context);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _hypnosisAudioPlayerController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = context.read<AudioPlayer>();
    return AudioPlayerControllerWidget(
      audioPlayer,
      context.read<ConnectivityStatusCubit>(),
      firebaseAnalytics: context.read<FirebaseAnalytics>(),
      child: Builder(builder: (innerContext) {
        return Stack(
          children: [
            widget.child,
            StreamBuilder(
              stream: innerContext.hypnosisAudioPlayer.audioSourceStream,
              builder: (BuildContext context,
                  AsyncSnapshot<SequenceAudioSource?> snapshot) {
                final hasAudioSource =
                    innerContext.hypnosisAudioPlayer.audioSource != null;

                return hasAudioSource
                    ? StreamBuilder<bool?>(
                        stream:
                            innerContext.hypnosisAudioPlayer.visibilityStream,
                        builder: (context, snapshot) {
                          final isVisible = snapshot.data ?? false;
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Visibility(
                              visible: isVisible,
                              child: widget.playerWidget ??
                                  const SizedBox.shrink(),
                            ),
                          );
                        })
                    : const SizedBox.shrink();
              },
            ),
          ],
        );
      }),
    );
  }
}
