import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypnosis_downloads/app/connectivity_status/logic/connectivity_status_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

late ConnectivityStatusCubit connectivityStatusCubit;

// ignore: must_be_immutable
class AudioPlayerControllerWidget extends InheritedWidget {
  AudioPlayerControllerWidget(
    this._audioPlayer,
    this.connectivityStatusCubit, {
    required super.child,
    required this.firebaseAnalytics,
    super.key,
  });

  final ConnectivityStatusCubit connectivityStatusCubit;
  final FirebaseAnalytics firebaseAnalytics;

  static AudioPlayerControllerWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AudioPlayerControllerWidget>();
  }

  @override
  bool updateShouldNotify(AudioPlayerControllerWidget oldWidget) => true;

  final AudioPlayer _audioPlayer;

  /// Current audio source
  SequenceAudioSource? _audioSource;

  /// Current audio index
  int? _currentIndex;

  Product? currentAudio;

  /// The audio player instance.
  AudioPlayer get audioPlayer => _audioPlayer;

  final StreamController<int?> currentIndexController =
      StreamController.broadcast();

  Stream<int?> get currentIndexStream => currentIndexController.stream;

  final StreamController<SequenceAudioSource?> audioSourceController =
      StreamController.broadcast();

  Stream<SequenceAudioSource?> get audioSourceStream =>
      audioSourceController.stream;

  final StreamController<Product?> currentAudioController =
      StreamController.broadcast();

  SequenceAudioSource? get audioSource => _audioSource;

  Stream<Product?> get currentAudioStream => currentAudioController.stream;

  bool get isPlaying => _audioPlayer.playing;

  /// Stream of changes on audio duration.
  ///
  /// An event is going to be sent as soon as the audio duration is available
  /// (it might take a while to download or buffer it).
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  /// Stream of changes on audio position.
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  /// Roughly fires every 200 milliseconds. Will continuously update the position of the playback if the status is [PlayerState.playing].
  ///
  /// You can use it on a progress bar, for instance.
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  bool get canSeekToNext => _currentIndex != null && _audioSource != null
      ? _currentIndex! < _audioSource!.products.length - 1
      : false;

  bool get canSeekToPrevious => _currentIndex != null && _audioSource != null
      ? _currentIndex! > 0
      : false;

  bool? _visible;

  bool get visible => _visible ?? false;

  final StreamController<bool?> visibilityStreamController =
      StreamController<bool?>.broadcast();

  Stream<bool?> get visibilityStream => visibilityStreamController.stream;

  /// Set [SequenceAudioSource] audio source with [initialIndex] as the initial index.
  Future<void> setAudioSource(
      String id,
      SequenceAudioSourceType type,
      List<Product> products,
      Future<Product> Function(Product) useOfflineLinkIfAvailable,
      {int initialIndex = 0}) async {
    if (initialIndex < products.length && initialIndex >= 0) {
      // Log original products order
      debugPrint('[tagx] Original products order:');
      for (int i = 0; i < products.length; i++) {
        debugPrint(
            '[tagx] $i: ${products[i].id} - ${products[i].name} - ${products[i].orderTime}');
      }

      final sortedProducts = List<Product>.from(products)
        ..sort((a, b) => b.orderTime.compareTo(a.orderTime));

      // Log sorted products order
      debugPrint('[tagx] Sorted products order:');
      for (int i = 0; i < sortedProducts.length; i++) {
        debugPrint(
            '[tagx] $i: ${sortedProducts[i].id} - ${sortedProducts[i].name} - ${sortedProducts[i].orderTime}');
      }

      _audioSource = SequenceAudioSource(
        id,
        type,
        sortedProducts, // Use the sorted list
        useOfflineLinkIfAvailable,
        connectivityStatusCubit,
      );
      _currentIndex = initialIndex;
      debugPrint('[tagx] Initial index set to: $_currentIndex');

      currentIndexController.add(_currentIndex);
      audioSourceController.add(_audioSource);

      // When next audio in sequence starts playing, update _currentAudio
      _audioPlayer.playbackEventStream.listen((event) async {
        // Remove noisy logging
        // Only log significant events
        final anotherItemStartsPlaying =
            event.processingState == ProcessingState.ready &&
                event.currentIndex == (_currentIndex ?? 0) + 1;
        if (anotherItemStartsPlaying) {
          debugPrint(
              '[tagx] Auto-advancing to next item: ${event.currentIndex}');
          currentIndexController.add(_currentIndex);
          // https://app.clickup.com/t/862jdxjc7. Play automatically, but only for playlists, not for sessions.
          final isFromPlaylist =
              _audioSource!.type == SequenceAudioSourceType.playlist;
          if (isFromPlaylist) {
            // Only show the next audio if we need to start playing it. Not a big deal, but people that are using sessions to sleep asked for it.
            debugPrint(
                '[tagx] Playing next item from playlist at index: ${event.currentIndex}');
            await _selectItemAt(event.currentIndex!);
            await audioPlayer.play();
          } else {
            debugPrint('[tagx] Stopping playback (not a playlist)');
            await audioPlayer.stop();
          }
        }
      });

      await _selectItemAt(initialIndex);
      return await play();
    } else {
      debugPrint(
          '[tagx] Invalid index: $initialIndex for products length: ${products.length}');
      return Future.error("Invalid index");
    }
  }

  void show() {
    _visible = true;
    if (!_isDisposed) {
      visibilityStreamController.add(_visible);
    }
  }

  void hide() {
    _visible = false;
    if (!_isDisposed) {
      visibilityStreamController.add(_visible);
    }
  }

  /// Play current audio source from current index.
  Future<void> play() async {
    if (_audioSource != null && _currentIndex != null) {
      currentAudio = await _audioSource?.getProductAt(_currentIndex!);

      if (currentAudio != null) {
        return await _audioPlayer.play();
      } else {
        return Future.error("Can`t play audio");
      }
    } else {
      return Future.error("No audio source");
    }
  }

  /// Pause current audio source.
  Future<void> pause() async {
    return await _audioPlayer.pause();
  }

  /// Stop current audio source.
  Future<void> stop() async {
    return await _audioPlayer.stop();
  }

  Future<void> seek(Duration duration) async {
    if (_audioSource != null && _currentIndex != null) {
      final currentAudio = await _audioSource!.getProductAt(_currentIndex!);

      if (currentAudio != null) {
        final totalDuration = _audioPlayer.duration;

        if (totalDuration != null) {
          final newPosition = duration;

          if (newPosition < totalDuration) {
            return await _audioPlayer.seek(newPosition);
          } else {
            return await seekToNext();
          }
        } else {
          return Future.error("Can`t forward 30 seconds");
        }
      } else {
        return Future.error("Can`t play audio");
      }
    }
  }

  /// Seek to next audio in audio source.
  Future<void> seekToNext() async {
    debugPrint('[tagx] seekToNext called, current index: $_currentIndex');
    if (_audioSource != null && _currentIndex != null) {
      if (_currentIndex! < _audioSource!.products.length - 1) {
        final nextIndex = _currentIndex! + 1;
        debugPrint('[tagx] Seeking to next index: $nextIndex');

        // Log the next product details before selecting it
        if (nextIndex < _audioSource!.products.length) {
          final nextProduct = _audioSource!.products[nextIndex];
          debugPrint(
              '[tagx] Next product: ${nextProduct.id} - ${nextProduct.name}');
        }

        await _audioPlayer.stop();
        await _selectItemAt(nextIndex);
        return await play();
      } else {
        debugPrint('[tagx] Already at the end of playlist');
        // We are at the end of the playlist, so we should seek to the end of the current audio and stop playing.
        final currentAudio = await _audioSource!.getProductAt(_currentIndex!);
        // Seek to the end of the current audio.
        if (currentAudio != null) {
          final totalDuration = _audioPlayer.duration;
          if (totalDuration != null) {
            await _audioPlayer.seek(totalDuration);
          } else {
            debugPrint('[tagx] Cannot seek to end - duration is null');
            return Future.error("Can`t seek to the end of current audio");
          }
        } else {
          debugPrint('[tagx] Cannot seek to end - current audio is null');
          return Future.error("Can`t seek to the end of current audio");
        }
        // Stop playing.
        return await stop();
      }
    } else {
      debugPrint(
          '[tagx] Cannot seek to next - no audio source or current index');
      return Future.error("No audio source");
    }
  }

  /// Seek to previous audio in audio source.
  Future<void> seekToPrevious() async {
    if (_audioSource != null && _currentIndex != null) {
      if (_currentIndex! > 0) {
        await _selectItemAt(_currentIndex! - 1);
        return await play();
      } else {
        return Future.error("Can`t seek to previous");
      }
    } else {
      return Future.error("No audio source");
    }
  }

  /// Forward current audio for 30 seconds or play next audio if current audio is completed.
  Future<void> forward10Seconds() async {
    if (_audioSource != null && _currentIndex != null) {
      final currentAudio = _audioSource!.getCurrentAudioSource();

      final position = _audioPlayer.position;
      final duration = _audioPlayer.duration;

      if (duration != null) {
        final newPosition = position + const Duration(seconds: 10);

        if (newPosition < duration) {
          return await _audioPlayer.seek(newPosition);
        } else {
          return await seekToNext();
        }
      } else {
        return Future.error("Can`t forward 30 seconds");
      }
    } else {
      return Future.error("No audio source");
    }
  }

  /// Rewind current audio for 30 seconds or play previous audio if current audio is completed.
  Future<void> backward10Seconds() async {
    if (_audioSource != null && _currentIndex != null) {
      final currentAudio = _audioSource!.getCurrentAudioSource();

      final position = _audioPlayer.position;

      if (position == const Duration(seconds: 0)) {
        return await seekToPrevious();
      } else {
        final newPosition = position - const Duration(seconds: 10);

        if (newPosition > const Duration(seconds: 0)) {
          return await _audioPlayer.seek(newPosition);
        } else {
          return await _audioPlayer.seek(const Duration(seconds: 0));
        }
      }
    } else {
      return Future.error("No audio source");
    }
  }

  /// Dispose player and stops all related streams.
  void dispose() {
    // We need to keep stream controllers open for background playback
    // But we should handle cleanup in a way that prevents memory leaks

    // Instead of closing controllers, we can add a flag to track widget lifecycle
    _isDisposed = true;

    // Note: We're intentionally NOT closing these controllers or disposing the audio player
    // to maintain background playback functionality:
    // audioSourceController.close();
    // currentIndexController.close();
    // currentAudioController.close();
    // visibilityStreamController.close();
    // _audioPlayer.dispose();
  }

  /// Selects the item at [index] and plays it.
  Future<void> _selectItemAt(int index) async {
    debugPrint('[tagx] _selectItemAt called with index: $index');
    _currentIndex = index;
    currentIndexController.add(_currentIndex);

    final currentAudioSource = await _audioSource!.getCurrentAudioSource();
    currentAudio = await _audioSource!.getProductAt(index);

    if (currentAudio != null) {
      debugPrint(
          '[tagx] Selected product: ${currentAudio!.id} - ${currentAudio!.name}');
    } else {
      debugPrint('[tagx] Selected product is null for index: $index');
    }

    try {
      if (currentAudio != null && !currentAudio!.isFromPlaylist) {
        await audioPlayer.stop();
      }
    } on StateError catch (e) {
      debugPrint('StateError: $e');
    }
    unawaited(firebaseAnalytics.logEvent(
      name: 'play_audio',
      parameters: {
        'audio_id': currentAudio?.id ?? "Unknown ID",
        'audio_name': currentAudio?.name ?? "Unknown name",
        'audio_type': currentAudio?.type.toString() ?? "Unknown type",
      },
    ));
    currentAudioController.add(currentAudio);
    currentIndexController.add(_currentIndex);
    audioSourceController.add(_audioSource);

    await audioPlayer.setAudioSource(currentAudioSource);
    try {
      debugPrint('[tagx] Seeking to Duration.zero with index: $_currentIndex');
      await audioPlayer.seek(Duration.zero, index: _currentIndex);
    } catch (e) {
      debugPrint('[tagx] Error seeking to index $_currentIndex: $e');
      debugPrint(
          'Cannot seek to next audio. Perhaps the playlist is completed.');
    }
  }

  bool _isDisposed = false;
}

class SequenceAudioSource {
  SequenceAudioSource(
    this.id,
    this.type,
    this.products,
    this.useOfflineLinkIfAvailable,
    this.connectivityStatusCubit,
  );

  final String id;
  final List<Product> products;
  final SequenceAudioSourceType type;
  final Future<Product> Function(Product) useOfflineLinkIfAvailable;
  final ConnectivityStatusCubit connectivityStatusCubit;

  // Add a static variable to cache the silence mp3 URI
  static Uri? _cachedSilenceMp3Uri;
  static File? _silenceMp3File;

  Future<AudioSource> getCurrentAudioSource() async {
    final mediaItems = <AudioSource>[];
    debugPrint(
        '[tagx] Building audio sources from ${products.length} products');

    // Remove individual audio source logging - too verbose
    for (int i = 0; i < products.length; i++) {
      final product = products[i];
      final downloadedProduct = await useOfflineLinkIfAvailable.call(product);

      Uri uri;

      if (downloadedProduct.link.contains('http')) {
        uri = Uri.parse(downloadedProduct.link);
        final isOffline =
            connectivityStatusCubit.state is! ConnectivityStatusOnline;
        if (isOffline) {
          debugPrint('[tagx] Using silence MP3 for offline mode');
          final silenceMp3 =
              await _readSilenceMp3FromInternalFilesBecauseAudioPlayerOnAndroidCanNotProperlyPlayAudioFromAssets();
          uri = silenceMp3;
        }
      } else {
        uri = Uri.file(downloadedProduct.link);
      }
      if (downloadedProduct.link.contains('.pdf')) {
        // Skip pdf files because they are not supported by audio player
        debugPrint('[tagx] Skipping PDF file: ${downloadedProduct.name}');
        continue;
      }
      final audioSource = AudioSource.uri(
        uri,
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: downloadedProduct.id,
          // Metadata to display in the notification:
          album: "Hypnosis Downloads",
          title: downloadedProduct.name,
          artUri: null, // Either use a local asset or nothing at all
        ),
      );
      mediaItems.add(audioSource);
    }

    debugPrint('[tagx] Created ${mediaItems.length} audio sources');
    return ConcatenatingAudioSource(children: mediaItems);
  }

  String? getNameAt(int index) {
    if (index >= 0 && index < products.length) {
      return products.elementAt(index).name;
    } else {
      return null;
    }
  }

  Future<Product?> getProductAt(int index) async {
    if (index >= 0 && index < products.length) {
      // No sorting here - we already sorted when creating the audio source
      final product = products.elementAt(index);
      final downloadedProduct = await useOfflineLinkIfAvailable.call(product);
      return downloadedProduct;
    } else {
      return null;
    }
  }

  Future<Uri>
      _readSilenceMp3FromInternalFilesBecauseAudioPlayerOnAndroidCanNotProperlyPlayAudioFromAssets() async {
    // Return cached URI if available
    if (_cachedSilenceMp3Uri != null) {
      return _cachedSilenceMp3Uri!;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      // Read silence.mp3 from assets
      final file = await rootBundle.load('assets/silence.mp3');

      // Save to temporary directory with a unique, consistent filename
      final tempDir = await getTemporaryDirectory();
      final fileTemp = File(
          '${tempDir.path}/hypnosis_silence_${DateTime.now().millisecondsSinceEpoch}.mp3');

      // Use uri to this file
      await fileTemp.writeAsBytes(file.buffer.asUint8List());

      // Cache the URI and file reference
      _cachedSilenceMp3Uri = Uri.file(fileTemp.path);
      _silenceMp3File = fileTemp;

      return _cachedSilenceMp3Uri!;
    } else {
      _cachedSilenceMp3Uri = Uri.parse(
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
      return _cachedSilenceMp3Uri!;
    }
  }

  // Add a static cleanup method
  static void cleanupSilenceMp3() {
    if (_silenceMp3File != null && _silenceMp3File!.existsSync()) {
      try {
        _silenceMp3File!.deleteSync();
      } catch (e) {
        debugPrint('Error deleting silence mp3 file: $e');
      }
      _silenceMp3File = null;
      _cachedSilenceMp3Uri = null;
    }
  }
}

enum SequenceAudioSourceType {
  pack,
  playlist,
}
