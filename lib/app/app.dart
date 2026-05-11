import 'package:authentication_logic/authentication_logic.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/connectivity_status/logic/connectivity_status_cubit.dart';
import 'package:hypnosis_downloads/app/home/page_index_provider.dart';
import 'package:hypnosis_downloads/app/splash/splash_page.dart';
import 'package:hypnosis_downloads/app/view/app_view.dart';
import 'package:hypnosis_downloads/playlists/create_playlist/cubit/create_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/playlists/data/playlists_repository.dart';
import 'package:hypnosis_downloads/playlists/playlist/add_to_playlist/cubit/cubit/add_to_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/common/remove_from_playlist/cubit/remove_from_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/edit/cubit/edit_playlist_name_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/data/downloadable_products_repository.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/recent_downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/cubit/products_cubit.dart';
import 'package:hypnosis_downloads/products/data/products_repository.dart';
import 'package:hypnosis_downloads/search/playlists_search/playlists_search_bloc.dart';
import 'package:hypnosis_downloads/search/product_search/product_search_bloc.dart';
import 'package:hypnosis_downloads/library/cubit/sessions_cubit.dart';
import 'package:hypnosis_downloads/library/data/sessions_repository.dart';
import 'package:hypnosis_downloads/library/view/components/latest_news/logic/latest_news_cubit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    this.initialPage = const SplashPage(),
    Key? key,
    required this.currentUserRepository,
    required this.loginWithEmailPasswordRepository,
    required this.registerWithEmailPasswordRepository,
    required this.restorePasswordRepository,
    required this.logoutRepository,
    required this.downloadableProductsRepository,
    required this.sessionsRepository,
    required this.playlistsRepository,
    required this.productsRepository,
    required this.audioPlayer,
    required this.connectivity,
    required this.firebaseAnalytics,
  }) : super(key: key);

  final Widget initialPage;
  final CurrentUserRepository currentUserRepository;
  final LoginWithEmailPasswordRepository loginWithEmailPasswordRepository;
  final RegisterWithEmailPasswordRepository registerWithEmailPasswordRepository;
  final RestorePasswordRepository restorePasswordRepository;
  final DownloadableProductsRepository downloadableProductsRepository;
  final SessionsRepository sessionsRepository;
  final PlaylistsRepository playlistsRepository;
  final ProductsRepository productsRepository;
  final LogoutRepository logoutRepository;
  final AudioPlayer audioPlayer;
  final Connectivity connectivity;
  final FirebaseAnalytics firebaseAnalytics;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioPlayer>(
          create: (_) => audioPlayer,
        ),
        BlocProvider(
          create: (context) => CurrentUserCubit(currentUserRepository),
        ),
        BlocProvider<LoginWithEmailPasswordCubit>(
          create: (context) => LoginWithEmailPasswordCubit(
              loginWithEmailPasswordRepository, currentUserRepository),
        ),
        BlocProvider<RegisterWithEmailPasswordCubit>(
          create: (context) => RegisterWithEmailPasswordCubit(
              registerWithEmailPasswordRepository, currentUserRepository),
        ),
        BlocProvider<RestorePasswordCubit>(
          create: (context) => RestorePasswordCubit(restorePasswordRepository),
        ),
        BlocProvider<LatestNewsCubit>(
          create: (context) => LatestNewsCubit(),
        ),
        BlocProvider<LogoutCubit>(
          create: (context) => LogoutCubit(logoutRepository),
        ),
        BlocProvider<SessionsCubit>(
          create: (context) => SessionsCubit(sessionsRepository),
        ),
        BlocProvider<ProductSearchBloc>(
          create: (context) => ProductSearchBloc(),
        ),
        BlocProvider<PlaylistsCubit>(
          create: (context) =>
              PlaylistsCubit(playlistsRepository, currentUserRepository),
        ),
        BlocProvider<CreatePlaylistCubit>(
          create: (context) =>
              CreatePlaylistCubit(playlistsRepository, currentUserRepository),
        ),
        BlocProvider<EditPlaylistNameCubit>(
          create: (context) =>
              EditPlaylistNameCubit(playlistsRepository, currentUserRepository),
        ),
        BlocProvider<AddToPlaylistCubit>(
          create: (context) => AddToPlaylistCubit(playlistsRepository),
        ),
        BlocProvider<RemoveFromPlaylistCubit>(
          create: (context) => RemoveFromPlaylistCubit(playlistsRepository),
        ),
        BlocProvider<DownloadableProductsCubit>(
          create: (context) =>
              DownloadableProductsCubit(downloadableProductsRepository),
        ),
        BlocProvider<RecentDownloadableProductsCubit>(
          create: (context) =>
              RecentDownloadableProductsCubit(downloadableProductsRepository),
        ),
        BlocProvider<PlaylistsSearchBloc>(
          create: (context) => PlaylistsSearchBloc(),
        ),
        BlocProvider<ProductsCubit>(
          create: (context) => ProductsCubit(productsRepository),
        ),
        BlocProvider<ConnectivityStatusCubit>(
          create: (context) => ConnectivityStatusCubit(connectivity),
        ),
        Provider<FirebaseAnalytics>(
          create: (_) => firebaseAnalytics,
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => PageIndexProvider(),
        child: AppView(
          initialPage: initialPage,
        ),
      ),
    );
  }
}
