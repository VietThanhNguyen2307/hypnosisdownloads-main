import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/connectivity_status/logic/connectivity_status_cubit.dart';
import 'package:hypnosis_downloads/app/home/page_index_provider.dart';
import 'package:hypnosis_downloads/app/home/routes/listen_routes.dart';
import 'package:hypnosis_downloads/app/home/routes/playlists_routes.dart';
import 'package:hypnosis_downloads/app/home/routes/sessions_routes.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_navigation_bar.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/components/successful_snackbar.dart';
import 'package:hypnosis_downloads/audio_player/audio_player.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/playlists/create_playlist/cubit/create_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/add_to_playlist/cubit/cubit/add_to_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/common/remove_from_playlist/cubit/remove_from_playlist_cubit.dart';
import 'package:hypnosis_downloads/products/audios/player/view/components/hypnosis_mini_audio_player.dart';
import 'package:hypnosis_downloads/users/profile/profile_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page<void> get page => const MaterialPage<void>(child: HomePage());

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const HomePage());

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sessionsNavigatorKey = GlobalKey<NavigatorState>();
  final playlistsNavigatorKey = GlobalKey<NavigatorState>();
  final listenNavigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    unawaited(context.read<ConnectivityStatusCubit>().onPageOpened());
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => _initTrackingTransparencyPlugin(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex =
        Provider.of<PageIndexProvider>(context, listen: false).activeIndex;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Set status bar color
        statusBarIconBrightness: activeIndex == 0
            ? Brightness.light
            : Brightness.dark // Set status bar icons color
        // Set status bar icons color
        ));
    return MultiBlocListener(
      listeners: [
        BlocListener<AddToPlaylistCubit, AddToPlaylistState>(
          listener: (context, state) {
            if (state is AddToPlaylistFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Failed to add to playlist'),
                  ),
                );
            }
            if (state is AddToPlaylistSuccess) {
              SuccessfulSnackbar.show(
                context,
                'Successfully added to playlist "${state.playlistName}"',
              );
              unawaited(context.read<PlaylistsCubit>().onPageOpened());
            }
          },
          child: Container(),
        ),
        BlocListener<RemoveFromPlaylistCubit, RemoveFromPlaylistState>(
          listener: (context, state) {
            if (state is RemoveFromPlaylistFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Failed to remove from playlist'),
                  ),
                );
            }
            if (state is RemoveFromPlaylistSuccess) {
              SuccessfulSnackbar.show(
                context,
                'Successfully removed from playlist',
              );
              unawaited(context.read<PlaylistsCubit>().onPageOpened());
            }
          },
          child: BlocListener<CreatePlaylistCubit, CreatePlaylistState>(
            listener: (context, state) {
              if (state is CreatePlaylistSuccess) {
                context.read<PlaylistsCubit>().onPageOpened();
                SuccessfulSnackbar.show(
                  context,
                  'Playlist created successfully',
                );
              }

              if (state is CreatePlaylistFailure) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                    ),
                  );
              }

              if (state is CreatePlaylistInProgress) {
                context.loaderOverlay.show();
              } else {
                context.loaderOverlay.hide();
              }
            },
          ),
        ),
      ],
      child: DisableSwipeToGoBackOnAndroid(
        sessionsNavigatorKey: sessionsNavigatorKey,
        playlistsNavigatorKey: playlistsNavigatorKey,
        listenNavigatorKey: listenNavigatorKey,
        child: Scaffold(
          extendBody: true,
          body: AudioPlayerWrapper(
            playerWidget:
                HypnosisMiniAudioPlayer(navigatorKey: sessionsNavigatorKey),
            child: CustomLoaderOverlay(
              child: Selector(
                selector: (context, provider) =>
                    Provider.of<PageIndexProvider>(context).activeIndex,
                builder: ((context, value, child) {
                  if (value == 0 &&
                      sessionsNavigatorKey.currentContext != null) {
                    Navigator.of(sessionsNavigatorKey.currentContext!)
                        .popUntil((route) => route.isFirst);
                  } else if (value == 1 &&
                      listenNavigatorKey.currentContext != null) {
                    Navigator.of(listenNavigatorKey.currentContext!)
                        .popUntil((route) => route.isFirst);
                  } else if (value == 2 &&
                      playlistsNavigatorKey.currentContext != null) {
                    Navigator.of(playlistsNavigatorKey.currentContext!)
                        .popUntil((route) => route.isFirst);
                  }
                  return IndexedStack(
                    index: value as int,
                    children: [
                      Navigator(
                        key: sessionsNavigatorKey,
                        onGenerateRoute: onGenerateLibraryRoute,
                      ),
                      Navigator(
                        key: listenNavigatorKey,
                        onGenerateRoute: onGenerateListenRoute,
                      ),
                      Navigator(
                        key: playlistsNavigatorKey,
                        onGenerateRoute: onGeneratePlaylistsRoute,
                      ),
                      const ProfilePage(),
                    ],
                  );
                }),
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            onTap: (index) {
              Provider.of<PageIndexProvider>(context, listen: false)
                  .setActiveIndex(activeIndex: index);
            },
            items: [
              CustomNavbarItemModel(
                icon: IconsBold.documentDownload,
                label: 'Library',
              ),
              CustomNavbarItemModel(
                icon: IconsBold.headphone,
                label: 'Listen',
              ),
              CustomNavbarItemModel(
                icon: IconsBold.taskSquare,
                label: 'Playlists',
              ),
              CustomNavbarItemModel(
                icon: IconsBold.user,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisableSwipeToGoBackOnAndroid extends StatelessWidget {
  const DisableSwipeToGoBackOnAndroid({
    required this.child,
    super.key,
    required this.sessionsNavigatorKey,
    required this.playlistsNavigatorKey,
    required this.listenNavigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> sessionsNavigatorKey;
  final GlobalKey<NavigatorState> playlistsNavigatorKey;
  final GlobalKey<NavigatorState> listenNavigatorKey;

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? WillPopScope(
            onWillPop: () async {
              final mainNavigator = Navigator.of(context);
              final nestedNavigatorA =
                  Navigator.of(sessionsNavigatorKey.currentContext!);
              final nestedNavigatorB =
                  Navigator.of(playlistsNavigatorKey.currentContext!);

              final nestedNavigatorC =
                  Navigator.of(listenNavigatorKey.currentContext!);

              if (nestedNavigatorA.canPop()) {
                nestedNavigatorA.pop();
                context.hypnosisAudioPlayer.show();
                return false;
              }
              if (nestedNavigatorB.canPop()) {
                nestedNavigatorB.pop();
                context.hypnosisAudioPlayer.show();
                return false;
              }
              if (nestedNavigatorC.canPop()) {
                nestedNavigatorC.pop();
                context.hypnosisAudioPlayer.show();
                return false;
              }
              return !mainNavigator.canPop();
            },
            child: child,
          )
        : child;
  }
}

Future<void> _initTrackingTransparencyPlugin(BuildContext context) async {
  final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
  // If the system can show an authorization request dialog
  if (status == TrackingStatus.notDetermined) {
    // Request system's tracking authorization dialog
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}
