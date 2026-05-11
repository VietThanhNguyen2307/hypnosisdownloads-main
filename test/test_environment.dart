import 'package:authentication_logic/authentication_logic.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hypnosis_downloads/app/app.dart';
import 'package:hypnosis_downloads/audio_player/audio_player.dart';
import 'package:hypnosis_downloads/playlists/data/playlists_repository.dart';
import 'package:hypnosis_downloads/products/audios/download/data/downloadable_products_repository.dart';
import 'package:hypnosis_downloads/products/audios/player/view/components/hypnosis_mini_audio_player.dart';
import 'package:hypnosis_downloads/products/data/products_repository.dart';
import 'package:hypnosis_downloads/library/data/sessions_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/annotations.dart';

import 'test_environment.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CurrentUserRepository>(),
  MockSpec<LoginWithEmailPasswordRepository>(),
  MockSpec<RestorePasswordRepository>(),
  MockSpec<LogoutRepository>(),
  MockSpec<DownloadableProductsRepository>(),
  MockSpec<SessionsRepository>(),
  MockSpec<PlaylistsRepository>(),
  MockSpec<ProductsRepository>(),
  MockSpec<AudioPlayer>(),
  MockSpec<Connectivity>(),
])
class TestEnvironment {
  TestEnvironment() {
    _mockAllRepositories();
  }
  late List<dynamic> repositories;
  final sessionsNavigatorKey = GlobalKey<NavigatorState>();

  Future<void> openWith(WidgetTester tester, Widget page) async {
    return await _launchWith(tester, _createAppAt(page));
  }

  void _mockAllRepositories() {
    repositories = [
      MockCurrentUserRepository(),
      MockLoginWithEmailPasswordRepository(),
      MockRestorePasswordRepository(),
      MockLogoutRepository(),
      MockDownloadableProductsRepository(),
      MockSessionsRepository(),
      MockPlaylistsRepository(),
      MockProductsRepository(),
      MockAudioPlayer(),
      MockConnectivity(),
    ];
  }

  Future<void> _launchWith(WidgetTester tester, Widget app) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    return await tester.pumpWidget(app);
  }

  Widget _createAppAt(Widget page) {
    return App(
      initialPage: AudioPlayerWrapper(
          playerWidget:
              HypnosisMiniAudioPlayer(navigatorKey: sessionsNavigatorKey),
          child: page),
      currentUserRepository: repositories.at<CurrentUserRepository>(),
      loginWithEmailPasswordRepository:
          repositories.at<LoginWithEmailPasswordRepository>(),
      restorePasswordRepository: repositories.at<RestorePasswordRepository>(),
      logoutRepository: repositories.at<LogoutRepository>(),
      downloadableProductsRepository:
          repositories.at<DownloadableProductsRepository>(),
      sessionsRepository: repositories.at<SessionsRepository>(),
      playlistsRepository: repositories.at<PlaylistsRepository>(),
      productsRepository: repositories.at<ProductsRepository>(),
      audioPlayer: repositories.at<AudioPlayer>(),
      connectivity: repositories.at<Connectivity>(),
      registerWithEmailPasswordRepository:
          repositories.at<RegisterWithEmailPasswordRepository>(),
      firebaseAnalytics: repositories.at<FirebaseAnalytics>(),
    );
  }
}

extension Extras on List<dynamic> {
  T at<T>() {
    return firstWhere((repository) => repository is T);
  }
}
