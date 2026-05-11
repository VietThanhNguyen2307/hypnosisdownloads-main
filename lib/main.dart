import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:authentication_logic/authentication_logic.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hypnosis_downloads/app/app.dart';
import 'package:hypnosis_downloads/app/bloc_observer.dart';
import 'package:hypnosis_downloads/app/config.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/data/playlists_repository.dart';
import 'package:hypnosis_downloads/products/audios/download/data/downloadable_products_repository.dart';
import 'package:hypnosis_downloads/products/data/products_repository.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:hypnosis_downloads/library/data/sessions_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'firebase_options.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final httpClient = Dio(Config.baseOptions);
    final firebaseAnalytics = FirebaseAnalytics.instance;
    httpClient.interceptors
        .add(CurlLoggerDioInterceptor(printOnSuccess: false));
    await cacheNetworkResponses(httpClient);

    await Hive.initFlutter();
    await initDatabase();

    await clearCacheIfNeeded();

    await FlutterDownloader.initialize(debug: kDebugMode);

    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kReleaseMode);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    Bloc.observer = AppBlocObserver();

    await configureAudioSession();

    final currentUserBox = await Hive.openBox<CurrentUser>('current_user');
    final currentUserRepository = CurrentUserRepository(currentUserBox);

    httpClient.interceptors.add(InterceptorsWrapper(onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        currentUserRepository.deleteCurrentUser();
      }
      return handler.next(error);
    }));

    final playlistsBox = await Hive.openBox<Playlist>('playlists');
    final audioPlayer = AudioPlayer();

    final connectivity = Connectivity();

    runApp(App(
      currentUserRepository: currentUserRepository,
      loginWithEmailPasswordRepository:
          LoginWithEmailPasswordRepository(httpClient),
      registerWithEmailPasswordRepository:
          RegisterWithEmailPasswordRepository(httpClient),
      restorePasswordRepository: RestorePasswordRepository(httpClient),
      logoutRepository: LogoutRepository(currentUserRepository),
      downloadableProductsRepository: DownloadableProductsRepository(),
      sessionsRepository: SessionsRepository(httpClient, currentUserRepository),
      playlistsRepository:
          PlaylistsRepository(httpClient, playlistsBox, currentUserRepository),
      productsRepository: ProductsRepository(httpClient),
      audioPlayer: audioPlayer,
      connectivity: connectivity,
      firebaseAnalytics: firebaseAnalytics,
    ));
  }, (error, trace) {
    FirebaseCrashlytics.instance.recordError(error, trace);
  });
}

Future<void> clearCacheIfNeeded() async {
  final prefs = await SharedPreferences.getInstance();
  final storedVersionNumber = prefs.getString('app_version');

  // Get the package info
  final packageInfo = await PackageInfo.fromPlatform();

  // Get the current version name
  final currentVersionNumber = packageInfo.version;

  // Check if the app has been updated
  if (storedVersionNumber != currentVersionNumber || kDebugMode) {
    // Delete app_flutter folder inside getApplicationSupportDirectory()
    final appSupportDirectory = await getApplicationSupportDirectory();
    final appSupportDirectoryPath = appSupportDirectory.path;
    final appFlutterDirectoryPath = '$appSupportDirectoryPath/app_flutter';
    final appFlutterDirectory = Directory(appFlutterDirectoryPath);
    if (appFlutterDirectory.existsSync()) {
      appFlutterDirectory.deleteSync(recursive: true);
    }

    // Store the current version number in shared preferences
    await prefs.setString('app_version', currentVersionNumber);
  }
}

Future<void> initDatabase() async {
  Hive
    ..registerAdapter(PlaylistAdapter())
    ..registerAdapter(ProductPackAdapter())
    ..registerAdapter(ProductTypeAdapter())
    ..registerAdapter(DownloadProductTypeAdapter())
    ..registerAdapter(ProductAdapter())
    ..registerAdapter(CurrentUserAdapter());

  await Hive.openBox<ProductPack>('packs');
  await Hive.openBox<ProductPack>('audioPacks');
  await Hive.openBox<ProductPack>('scriptPacks');
  await Hive.openBox<ProductPack>('audioWithScriptPacks');
  await Hive.openBox<Product>('recentAudios');
  await Hive.openBox<Product>('audios');
  await Hive.openBox<Product>('scripts');
}

Future<void> configureAudioSession() async {
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration.speech());

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
}

Future<Directory> onlyUseCacheIfOffline(Dio httpClient) async {
  var isOnline = false;
  Connectivity().onConnectivityChanged.listen((event) {
    isOnline = event != ConnectivityResult.none;
  });
  final directory = await getApplicationSupportDirectory();
  httpClient.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options, handler) async {
      final key = CacheOptions.defaultCacheKeyBuilder(options);
      final cache = await HiveCacheStore(directory.path).get(key);
      if (cache != null && !isOnline) {
        return handler.resolve(cache.toResponse(options, fromNetwork: false));
      }
      return handler.next(options);
    },
  ));
  return directory;
}

Future<void> cacheNetworkResponses(Dio httpClient) async {
  await onlyUseCacheIfOffline(httpClient);

  final directory = await getApplicationSupportDirectory();
  final options = CacheOptions(
    allowPostMethod:
        true, // Workaround for APIs that require POST requests to GET content
    store: HiveCacheStore(directory.path),
  );
  httpClient.interceptors.add(DioCacheInterceptor(options: options));
}
