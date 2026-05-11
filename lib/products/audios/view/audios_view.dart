import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/library/quick_breaks/quick_breaks_view.dart';
import 'package:hypnosis_downloads/products/audios/view/components/recent_products_section.dart';
import 'package:hypnosis_downloads/products/audios/view/components/your_audio_packs_list_view.dart';
import 'package:hypnosis_downloads/library/cubit/sessions_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:url_launcher/url_launcher.dart';

class AudiosView extends StatefulWidget {
  const AudiosView({super.key});

  @override
  State<AudiosView> createState() => _AudiosViewState();
}

class _AudiosViewState extends State<AudiosView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsCubit, SessionsState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: buildContent(context, state),
        );
      },
    );
  }

  Widget buildContent(BuildContext context, SessionsState state) {
    if (state is SessionsLoadSuccess) {
      final audios = context.read<SessionsCubit>().audios;
      audios.sort((a, b) => b.orderTime.compareTo(a.orderTime));
      final audioPacks = context.read<SessionsCubit>().audioPacks +
          context.read<SessionsCubit>().audioWithScriptPacks;
      audioPacks.sort((a, b) => b.orderTime.compareTo(a.orderTime));
      if (audios.isEmpty && audioPacks.isEmpty) {
        return buildEmptyView();
      } else {
        final recentAudiosPack = ProductPack(
          'generated',
          'Recent Audios',
          DateTime.now(),
          audios,
          DownloadProductType.audio,
        );
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              RecentProductsSection(
                pack: recentAudiosPack,
              ),
              QuickBreaksSection(),
              const SizedBox(height: 16),
              YourAudioPackListView(
                yourAudioPacks: [
                  ...state.session.audioPacks,
                  ...state.session.audioWithScriptPacks
                ],
              ),
            ],
          ),
        );
      }
    } else if (state is SessionsLoadInProgress) {
      return buildProgressWidget();
    } else if (state is SessionsLoadFailure) {
      return buildErrorWidget(state.errorMessage);
    }
    return nothing;
  }

  Widget buildProgressWidget() => const Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: LoadingView(),
      );

  Widget buildErrorWidget(String errorMessage) => Center(
        child: BodyMediumText.dark(errorMessage),
      );

  Widget buildEmptyView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        const BodyMediumText.dark(
          // ignore: lines_longer_than_80_chars
          'You have no hypnosis sessions on your account. Visit Hypnosis Downloads for more information',
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          'Visit Website',
          onTap: () async =>
              launchUrl(Uri.parse('https://hypnosisdownloads.com')),
        ),
      ],
    );
  }
}

class QuickBreaksSection extends StatefulWidget {
  const QuickBreaksSection({
    super.key,
  });

  @override
  State<QuickBreaksSection> createState() => _QuickBreaksSectionState();
}

class _QuickBreaksSectionState extends State<QuickBreaksSection> {
  @override
  void initState() {
    super.initState();
    context.read<CurrentUserCubit>().onPageOpened();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        if (state is CurrentUserLoadInProgress) {
          return const LoadingView();
        }
        if (state is Authenticated &&
            state.currentUser.isGrowthZoneMember == true) {
          return Column(
            children: [
              const SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  quickBreaksMode.value = true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/quick_breaks.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          );
        }
        return nothing;
      },
    );
  }
}
