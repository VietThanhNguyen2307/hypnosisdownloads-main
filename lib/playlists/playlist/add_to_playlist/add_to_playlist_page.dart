import 'dart:async';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/common/shadows.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/playlist/add_to_playlist/cubit/cubit/add_to_playlist_cubit.dart';
import 'package:hypnosis_downloads/playlists/playlist/add_to_playlist/view/add_to_playlist_view.dart';
import 'package:hypnosis_downloads/products/cubit/products_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';

class AddToPlaylistPage extends StatefulWidget {
  const AddToPlaylistPage({Key? key, required this.playlist}) : super(key: key);

  final Playlist playlist;

  static Page<void> page(Playlist playlist) => MaterialPage<void>(
        child: AddToPlaylistPage(
          playlist: playlist,
        ),
      );

  static MaterialPageRoute<dynamic> route(Playlist playlist) =>
      MaterialPageRoute(
        builder: (context) => AddToPlaylistPage(playlist: playlist),
      );

  @override
  State<AddToPlaylistPage> createState() => _AddToPlaylistPageState();
}

class _AddToPlaylistPageState extends State<AddToPlaylistPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          },
        ),
      ],
      child: FutureBuilder<List<ProductPack>>(
        future: context.read<ProductsCubit>().getPacks(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductPack>> snapshot) {
          return Scaffold(
            appBar: CustomAppBar.secondary(
              title: widget.playlist.name,
              centerTitle: false,
              onBackButtonPressed: () {
                Navigator.of(context).pop();
                unawaited(context.read<PlaylistsCubit>().onPageOpened());
              },
            ),
            body: snapshot.hasData
                ? AddToPlaylistView(
                    playlist: widget.playlist,
                    packs: snapshot.data ?? [],
                    onIndexChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                  )
                : const Center(
                    child: CustomLoadingIndicator(),
                  ),
            bottomNavigationBar: snapshot.hasData
                ? AddToPlaylistBottomNavigationBar(
                    index: currentIndex,
                    count: snapshot.data!.length,
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class AddToPlaylistBottomNavigationBar extends StatefulWidget {
  const AddToPlaylistBottomNavigationBar({
    Key? key,
    required this.count,
    required this.index,
  }) : super(key: key);

  final int count;
  final int index;

  @override
  State<AddToPlaylistBottomNavigationBar> createState() =>
      _AddToPlaylistBottomNavigationBarState();
}

class _AddToPlaylistBottomNavigationBarState
    extends State<AddToPlaylistBottomNavigationBar> {
  static const _bottomPadding = 8.0;

  // In different devices we don`t have an home button on screen,
  // so we need to calculate that padding by hands
  double calculateBottomPadding(BuildContext context) {
    if (MediaQuery.of(context).padding.bottom <= _bottomPadding) {
      return _bottomPadding;
    }

    return MediaQuery.of(context).padding.bottom;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.only(
          top: 8,
          bottom: calculateBottomPadding(context),
        ),
        decoration: BoxDecoration(
          color: ComponentColors.bottomNavbarColor,
          boxShadow: [Shadows.navbar],
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: CarouselIndicator(
              activeColor: ComponentColors.sliderActiveColor,
              color: ComponentColors.sliderInactiveColor,
              width: 8,
              height: 8,
              count: widget.count,
              index: widget.index,
              space: 6,
            ),
          ),
        ),
      ),
    );
  }
}
