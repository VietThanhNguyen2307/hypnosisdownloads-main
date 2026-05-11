import 'dart:async';
import 'dart:io';

import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/authentication/login_with_email_password/view/login_page.dart';
import 'package:hypnosis_downloads/library/cubit/sessions_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/recent_downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/cubit/products_cubit.dart';
import 'package:hypnosis_downloads/search/playlists_search/playlists_search_bloc.dart';
import 'package:hypnosis_downloads/search/product_search/product_search_bloc.dart';
import 'package:hypnosis_downloads/users/delete_account/delete_account_screen.dart';
import 'package:hypnosis_downloads/users/profile/view/components/dropdown_downloads_location.dart';
import 'package:hypnosis_downloads/users/profile/view/components/dropdown_settings_list_view.dart';
import 'package:hypnosis_downloads/users/profile/view/components/dropdown_settings_list_view_item.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Platform.isAndroid
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: DropdownDownloadsLocation(),
                )
              : nothing,
          DropdownSettingsListView(
            physics: const NeverScrollableScrollPhysics(),
            items: [
              DropdownSettingsListViewItem(
                icon: IconsOutlined.user,
                text: 'My account',
                onTap: () => launchUrl(
                  Uri.parse('https://www.hypnosisdownloads.com/login'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownSettingsListView(
            physics: const NeverScrollableScrollPhysics(),
            items: [
              DropdownSettingsListViewItem(
                icon: IconsOutlined.helpCenter,
                text: 'Help',
                onTap: () => launchUrl(
                  Uri.parse('https://www.hypnosisdownloads.com/help-center'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownSettingsListView(
            physics: const NeverScrollableScrollPhysics(),
            items: [
              DropdownSettingsListViewItem.logout(
                icon: IconsOutlined.logout,
                text: 'Logout',
                onTap: () => logout(context),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "©2024 Uncommon Knowledge Ltd, Boswell House, Argyll Square, Oban, UK PA34 4BD. Registered Company 03573107",
              style: TextStyle(
                fontSize: 10,
                color: ComponentColors.hintTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 2),
          InkWell(
            onTap: () {
              launchUrl(
                Uri.parse(
                  "https://www.hypnosisdownloads.com/help-center/privacy",
                ),
              );
            },
            child: const Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ComponentColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                DeleteAccountScreen.route,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Delete my account",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ComponentColors.defaultLabelTextColor,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void logout(BuildContext context) {
  unawaited(context.read<LogoutCubit>().logout());
  unawaited(context.read<DownloadableProductsCubit>().onLogout());
  unawaited(context.read<RecentDownloadableProductsCubit>().onLogout());
  unawaited(context.read<ProductsCubit>().onLogout());
  unawaited(context.read<SessionsCubit>().onLogout());
  context.read<ProductSearchBloc>().add(const ProductSearchLogout());
  context.read<PlaylistsSearchBloc>().add(const PlaylistsSearchLogout());

  unawaited(makeSureNewUsersWillNotSeeOldContent(context));
  context.hypnosisAudioPlayer.stop();
  Navigator.of(context).pushAndRemoveUntil(
    LoginPage.route,
    (route) => false,
  );
}

Future<void> makeSureNewUsersWillNotSeeOldContent(BuildContext context) async {
  await Hive.box<ProductPack>('packs').clear();
  await Hive.box<ProductPack>('audioPacks').clear();
  await Hive.box<ProductPack>('scriptPacks').clear();
  await Hive.box<ProductPack>('audioWithScriptPacks').clear();
  await Hive.box<Product>('recentAudios').clear();
  await Hive.box<Product>('audios').clear();
  await Hive.box<Product>('scripts').clear();
}
