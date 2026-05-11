import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/common/filtering_mode.dart';
import 'package:hypnosis_downloads/app/home/routes/playlists_routes.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_bottom_modal_sheet.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/label_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button_small.dart';
import 'package:hypnosis_downloads/playlists/data/model/playlist.dart';
import 'package:hypnosis_downloads/playlists/view/components/filter_bottom_sheet.dart';
import 'package:hypnosis_downloads/search/playlists_search/playlists_search_bloc.dart';
import 'package:provider/provider.dart';

class PlaylistsListView extends StatelessWidget {
  const PlaylistsListView({Key? key, required this.playlists})
      : super(key: key);

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                DefaultTextButtonSmall.icon(
                  'Sort by',
                  icon: SvgPicture.asset(
                    IconsOutlined.sort,
                    color: ComponentColors.defaultIconColor,
                  ),
                  onPressed: () =>
                      CustomBottomModalSheet.showBottomSheet<FilteringMode?>(
                    context: context,
                    builder: (context) => FilterBottomSheet(
                      initialFilter:
                          context.read<PlaylistsSearchBloc>().state.filter,
                      skipFilters: const [
                        FilteringMode.date,
                        FilteringMode.dateReversed,
                      ],
                    ),
                  ).then((value) {
                    if (value != null) {
                      context
                          .read<PlaylistsSearchBloc>()
                          .onFilterChanged(value);
                    }
                  }),
                ),
              ],
            ),
          ),
          _renderContent(_filterPlaylists(context, playlists)),
        ],
      ),
    );
  }

  // List<Playlist> sortPlaylists(List<Playlist> playlists,
  //     {PlaylistsSortState filter = PlaylistsSortState.none}) {
  //   switch (filter) {
  //     case PlaylistsSortState.none:
  //       return playlists;
  //     case PlaylistsSortState.alphabet:
  //       return playlists.where((playlist) => playlist.name.isNotEmpty).toList()
  //         ..sort(
  //             (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  //     case PlaylistsSortState.aplhabetReverse:
  //       return playlists.where((playlist) => playlist.name.isNotEmpty).toList()
  //         ..sort(
  //             (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
  //     case PlaylistsSortState.date:
  //       return playlists.where((playlist) => playlist.name.isNotEmpty).toList()
  //         ..sort((a, b) => (b.createdAt ?? DateTime.now())
  //             .compareTo(a.createdAt ?? DateTime.now()));
  //   }
  // }

  Widget _renderContent(List<Playlist> playlists) {
    return ListView.separated(
      itemCount: playlists.length,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (BuildContext context, int index) {
        final playlist = playlists[index];

        return PlaylistsListViewItem(
          playlist: playlist,
          onTap: () => pushPlaylistPage(context, playlist),
        );
      },
    );
  }

  List<Playlist> _filterPlaylists(
      BuildContext context, List<Playlist> playlists) {
    final filter = context.read<PlaylistsSearchBloc>().state.filter;

    switch (filter) {
      case FilteringMode.alphabet:
        return playlists..sort((a, b) => a.name.compareTo(b.name));
      case FilteringMode.aplhabetReversed:
        return playlists..sort((a, b) => b.name.compareTo(a.name));
      default:
        return playlists..sort((a, b) => b.id.compareTo(a.id));
    }
  }
}

class PlaylistsListViewItem extends StatelessWidget {
  const PlaylistsListViewItem({Key? key, required this.playlist, this.onTap})
      : super(key: key);

  final Playlist playlist;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ComponentColors.primaryCardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ComponentColors.primaryShadowColor.withOpacity(.12),
              blurRadius: 16,
            )
          ],
        ),
        child: Row(
          children: [
            buildPlaylistImage(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BodyMediumText.dark(
                    playlist.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 4),
                  LabelText(
                    playlist.products.isNotEmpty
                        ? '${playlist.products.length} files'
                        : 'No audios',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPlaylistImage() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ComponentColors.backgroundColor,
      ),
      child: Center(
        child: SizedBox.square(
          dimension: 40,
          child: SvgPicture.asset(
            IconsBold.music,
            color: ComponentColors.primaryColor,
          ),
        ),
      ),
    );
  }
}

// class Playlist extends Equatable {
//   const Playlist({required this.name, required this.id, required this.entries});

//   final String name;
//   final String id;
//   final List<Product> entries;

//   @override
//   List<Object?> get props => [name, id, entries];
// }
