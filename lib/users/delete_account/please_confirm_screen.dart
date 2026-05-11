import 'dart:async';
import 'dart:convert';

import 'package:authentication_logic/authentication_logic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/audio_player/audio_player_controller_widget_extension.dart';
import 'package:hypnosis_downloads/library/cubit/sessions_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/recent_downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/cubit/products_cubit.dart';
import 'package:hypnosis_downloads/search/playlists_search/playlists_search_bloc.dart';
import 'package:hypnosis_downloads/search/product_search/product_search_bloc.dart';
import 'package:hypnosis_downloads/users/delete_account/account_deleted_screen.dart';
import 'package:hypnosis_downloads/users/profile/view/profile_view.dart';

class PleaseConfirmScreen extends StatelessWidget {
  static MaterialPageRoute<dynamic> get route => MaterialPageRoute(
        builder: (context) => const PleaseConfirmScreen(),
      );

  const PleaseConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  DefaultIconButton(
                    SvgPicture.asset(Assets.shortArrowLeft),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  const BodyMediumText(
                    "Back",
                    color: ComponentColors.titleBodyTextColor,
                  )
                ],
              ),
              const Spacer(),
              Text(
                "Please confirm:",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                'No, take me back',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
              ThirdButton(
                'Yes, delete my account',
                onTap: () async {
                  final currentUser =
                      context.read<CurrentUserCubit>().currentUser;
                  final isSent =
                      await _createZendeskTicket(currentUser: currentUser);
                  if (context.mounted) {
                    if (isSent) {
                      _logout(context);
                      Navigator.push(
                        context,
                        AccountDeletedScreen.route,
                      );
                    } else {
                      _showSnackBar(context);
                    }
                  }
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(12),
        child: IntrinsicHeight(
          child: Center(
            child: Text(
              "Check your internet connection",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ComponentColors.snackBarTextColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );
}

void _logout(BuildContext context) {
  unawaited(context.read<LogoutCubit>().logout());
  unawaited(context.read<DownloadableProductsCubit>().onLogout());
  unawaited(context.read<RecentDownloadableProductsCubit>().onLogout());
  unawaited(context.read<ProductsCubit>().onLogout());
  unawaited(context.read<SessionsCubit>().onLogout());
  context.read<ProductSearchBloc>().add(const ProductSearchLogout());
  context.read<PlaylistsSearchBloc>().add(
        const PlaylistsSearchLogout(),
      );

  unawaited(
    makeSureNewUsersWillNotSeeOldContent(context),
  );
  context.hypnosisAudioPlayer.stop();
}

Future<bool> _createZendeskTicket({
  required CurrentUser currentUser,
}) async {
  String zendeskSubdomain = 'unk';
  String zendeskEmail = 'kirstin.asher@unk.com';
  String zendeskPassword = 'Boggy8:joker';

  Map<String, dynamic> ticketData = {
    'ticket': {
      'subject': 'HD App request: Delete account',
      'description': "Delete user account request for ${currentUser.email}",
    },
  };

  try {
    Dio dio = Dio();
    dio.options.baseUrl = 'https://$zendeskSubdomain.zendesk.com/api/v2';
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Basic ${base64Encode(utf8.encode('$zendeskEmail:$zendeskPassword'))}';
    Response response = await dio.post('/tickets', data: ticketData);

    if (response.statusCode == 201) return true;
    return false;
  } catch (error) {
    return false;
  }
}
