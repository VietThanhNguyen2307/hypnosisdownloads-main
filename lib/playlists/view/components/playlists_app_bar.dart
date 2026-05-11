import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/home/routes/playlists_routes.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/search/playlists_search/playlists_search_bloc.dart';
import 'package:provider/provider.dart';

class PlaylistsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PlaylistsAppBar({Key? key}) : super(key: key);

  @override
  State<PlaylistsAppBar> createState() => _PlaylistsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _PlaylistsAppBarState extends State<PlaylistsAppBar> {
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: showSearch
          ? CustomAppBar.search(
              onClearTap: () => setState(() {
                context.read<PlaylistsSearchBloc>().clear();
                showSearch = false;
              }),
              onChanged: (value) =>
                  context.read<PlaylistsSearchBloc>().onQueryChanged(value),
            )
          : CustomAppBar.primary(
              title: 'Playlists',
              actions: [
                InkWell(
                  onTap: () {
                    setState(() {
                      showSearch = true;
                    });
                  },
                  child: SvgPicture.asset(IconsOutlined.search),
                ),
                const SizedBox(width: 16),
                InkWell(
                  child: SvgPicture.asset(IconsOutlined.add),
                  onTap: () => pushCreateNewPlaylistPage(context),
                ),
              ],
            ),
    );
  }
}
