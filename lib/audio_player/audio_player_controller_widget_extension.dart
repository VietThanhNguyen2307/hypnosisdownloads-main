import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:just_audio/just_audio.dart';

extension AudioPlayerControllerWidgetExtension on BuildContext {
  HypnosisAudioPlayerExtensionHelper get hypnosisAudioPlayer =>
      HypnosisAudioPlayerExtensionHelper(AudioPlayerControllerWidget.of(this));
}

class HypnosisAudioPlayerExtensionHelper with ChangeNotifier {
  static final HypnosisAudioPlayerExtensionHelper _singleton =
      HypnosisAudioPlayerExtensionHelper._internal();
  late AudioPlayerControllerWidget _hypnosisAudioPlayerController;

  AudioPlayerControllerWidget get hypnosisAudioPlayerController =>
      _hypnosisAudioPlayerController;

  factory HypnosisAudioPlayerExtensionHelper(
      AudioPlayerControllerWidget? hypnosisAudioPlayerController) {
    if (hypnosisAudioPlayerController != null) {
      _singleton._hypnosisAudioPlayerController = hypnosisAudioPlayerController;
    }

    return _singleton;
  }

  HypnosisAudioPlayerExtensionHelper._internal();

  Stream<int?> get currentIndexStream =>
      _hypnosisAudioPlayerController.currentIndexStream;

  Stream<SequenceAudioSource?> get audioSourceStream =>
      _hypnosisAudioPlayerController.audioSourceStream;

  SequenceAudioSource? get audioSource =>
      _hypnosisAudioPlayerController.audioSource;

  Stream<Product?> get currentAudioStream =>
      _hypnosisAudioPlayerController.currentAudioStream;

  Product? get currentAudio => _hypnosisAudioPlayerController.currentAudio;

  /// The current audio player state.
  bool get playing => _hypnosisAudioPlayerController.isPlaying;

  /// Stream of changes on audio duration.
  ///
  /// An event is going to be sent as soon as the audio duration is available
  /// (it might take a while to download or buffer it).
  Stream<Duration?> get durationStream =>
      _hypnosisAudioPlayerController.durationStream;

  /// Stream of changes on audio position.
  Stream<PlayerState> get playerStateStream =>
      _hypnosisAudioPlayerController.playerStateStream;

  /// Roughly fires every 200 milliseconds. Will continuously update the position of the playback if the status is [PlayerState.playing].
  ///
  /// You can use it on a progress bar, for instance.
  Stream<Duration> get positionStream =>
      _hypnosisAudioPlayerController.positionStream;

  bool get canSeekToNext => _hypnosisAudioPlayerController.canSeekToNext;

  bool get canSeekToPrevious =>
      _hypnosisAudioPlayerController.canSeekToPrevious;

  bool get visible => _hypnosisAudioPlayerController.visible;

  Stream<bool?> get visibilityStream =>
      _hypnosisAudioPlayerController.visibilityStream;

  void show() => _hypnosisAudioPlayerController.show();

  void hide() => _hypnosisAudioPlayerController.hide();

  /// Set [SequenceAudioSource] audio source with [initialIndex] as the initial index.
  Future<void> setPlaylistAudioSource(Playlist playlist,
      {required Future<Product> Function(Product) useOfflineLinkIfAvailable,
      int initialIndex = 0}) async {
    return _hypnosisAudioPlayerController.setAudioSource(
      playlist.id,
      SequenceAudioSourceType.playlist,
      playlist.products
          .where((element) => element.type == DownloadProductType.audio)
          .toList(),
      useOfflineLinkIfAvailable,
      initialIndex: initialIndex,
    );
  }

  /// Set [SequenceAudioSource] audio source with [initialIndex] as the initial index.
  Future<void> setPackAudioSource(ProductPack pack,
      {required Future<Product> Function(Product) useOfflineLinkIfAvailable,
      int initialIndex = 0}) async {
    return _hypnosisAudioPlayerController.setAudioSource(
      pack.id,
      SequenceAudioSourceType.pack,
      pack.products
          .where((element) => element.type == DownloadProductType.audio)
          .toList(),
      useOfflineLinkIfAvailable,
      initialIndex: initialIndex,
    );
  }

  /// Play current audio source from current index.
  Future<void> play() async {
    return _hypnosisAudioPlayerController.play();
  }

  /// Pause current audio source.
  Future<void> pause() async {
    return _hypnosisAudioPlayerController.pause();
  }

  /// Stop current audio source.
  Future<void> stop() async {
    return await _hypnosisAudioPlayerController.stop();
  }

  Future<void> seek(Duration position) async {
    return await _hypnosisAudioPlayerController.seek(position);
  }

  /// Seek to next audio in audio source.
  Future<void> seekToNext() async {
    return _hypnosisAudioPlayerController.seekToNext();
  }

  /// Seek to previous audio in audio source.
  Future<void> seekToPrevious() async {
    try {
      return _hypnosisAudioPlayerController.seekToPrevious();
    } on PlatformException catch (e) {
      // If message contains "Loading interrupted", just log, otherwise throw.
      if (e.message?.contains('Loading interrupted') ?? false) {
        debugPrint(e.message);
      } else {
        rethrow;
      }
    }
  }

  /// Forward current audio for 30 seconds or play next audio if current audio is completed.
  Future<void> forward10Seconds() async {
    return _hypnosisAudioPlayerController.forward10Seconds();
  }

  /// Rewind current audio for 30 seconds or play previous audio if current audio is completed.
  Future<void> backward10Seconds() async {
    return _hypnosisAudioPlayerController.backward10Seconds();
  }

  @override
  void dispose() {
    _hypnosisAudioPlayerController.dispose();
    super.dispose();
  }
}
