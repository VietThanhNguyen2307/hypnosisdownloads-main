import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/products/audios/view/components/recent_products_section.dart';
import 'package:hypnosis_downloads/products/scripts/view/components/your_scripts_packs_list_view.dart';
import 'package:hypnosis_downloads/library/cubit/sessions_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:url_launcher/url_launcher.dart';

class ScriptsView extends StatelessWidget {
  const ScriptsView({Key? key}) : super(key: key);

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
      final scripts = context.read<SessionsCubit>().scripts;
      final scriptPacks = context.read<SessionsCubit>().scriptPacks;
      if (scripts.isEmpty && scriptPacks.isEmpty) {
        return buildEmptyView();
      } else {
        final recentScriptsPack = ProductPack(
          'generated',
          'Recent Scripts',
          DateTime.now(),
          scripts,
          DownloadProductType.script,
        );

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              RecentProductsSection(
                pack: recentScriptsPack,
              ),
              const SizedBox(height: 16),
              YourScriptsPackListView(
                yourScriptsPacks: scriptPacks,
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
