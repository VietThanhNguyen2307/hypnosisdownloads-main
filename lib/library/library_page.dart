import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/home/routes/sessions_routes.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/playlists/cubit/playlists_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/download/logic/recent_downloadable_products_cubit.dart';
import 'package:hypnosis_downloads/products/audios/view/components/your_audio_packs_list_view.dart';
import 'package:hypnosis_downloads/products/scripts/view/components/your_scripts_packs_list_view.dart';
import 'package:hypnosis_downloads/products/view/products_list_view.dart';
import 'package:hypnosis_downloads/search/product_search/product_search_bloc.dart';
import 'package:hypnosis_downloads/library/cubit/sessions_cubit.dart';
import 'package:hypnosis_downloads/library/data/model/product.dart';
import 'package:hypnosis_downloads/library/data/model/product_pack.dart';
import 'package:hypnosis_downloads/library/data/model/product_type.dart';
import 'package:hypnosis_downloads/library/view/components/latest_news/logic/latest_news_cubit.dart';
import 'package:hypnosis_downloads/library/view/components/sessions_app_bar.dart';
import 'package:hypnosis_downloads/library/view/library_view.dart';
import 'package:hypnosis_downloads/users/profile/view/profile_view.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  static Page<void> get page => const MaterialPage<void>(child: LibraryPage());

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const LibraryPage());

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  void initState() {
    unawaited(context.read<SessionsCubit>().onPageOpened());
    unawaited(context.read<LatestNewsCubit>().onAppOpened());
    unawaited(context.read<DownloadableProductsCubit>().onAppOpened());
    unawaited(context.read<RecentDownloadableProductsCubit>().onAppOpened());
    context.read<SessionsCubit>().stream.listen((state) {
      if (state is SessionsLoadSuccess && mounted) {
        final sessionsCubit = context.read<SessionsCubit>();
        final audios = sessionsCubit.audios;
        final scripts = sessionsCubit.scripts;
        final audioPacks = sessionsCubit.audioPacks;
        final scriptPacks = sessionsCubit.scriptPacks;
        final audioWithScriptPacks = sessionsCubit.audioWithScriptPacks;
        unawaited(context
            .read<RecentDownloadableProductsCubit>()
            .onPageOpened(audios + scripts));

        context.read<ProductSearchBloc>().fetchFromSource(
              products: List.from(audios)..addAll(scripts),
              packs: List.from(audioPacks)
                ..addAll(scriptPacks)
                ..addAll(audioWithScriptPacks),
            );

        // This needs to be called after SessionsCubit, when audios are saved to Hive, to make sure products are showing up inside the playlists
        unawaited(context.read<PlaylistsCubit>().onPageOpened());
      } else if (state is SessionsLoadFailure) {
        // Session was invalidated on the backend, after a user has changed password.
        // We need to log out, to make a user enter a new password and get current authentication token.
        if (state.errorMessage ==
            "type 'Null' is not a subtype of type 'List<dynamic>' in type cast") {
          logout(context);
        }
      }
    });
    super.initState();
  }

  @override
  void deactivate() {
    unawaited(context.read<DownloadableProductsCubit>().onLogout());
    unawaited(context.read<RecentDownloadableProductsCubit>().onLogout());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color
      statusBarIconBrightness: Brightness.light,
    ));
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).orientation == Orientation.portrait
            ? 0.0
            : 32.0,
      ),
      child: CustomLoaderOverlay(
        child: Scaffold(
          appBar: const SessionsAppBar(),
          body: BlocListener<ProductSearchBloc, ProductSearchState>(
            listener: (context, state) {
              if (state.status == ProductSearchStatus.success) {
                final foundProducts = state.productsSearchResult;
                unawaited(context
                    .read<DownloadableProductsCubit>()
                    .onPageOpened(foundProducts));
              }
            },
            child: BlocBuilder<ProductSearchBloc, ProductSearchState>(
              builder: (context, state) {
                if (state.status != ProductSearchStatus.initial) {
                  return SessionsSearchView(
                    products: state.productsSearchResult,
                    packs: state.packsSearchResult,
                    filter: state.filter,
                  );
                } else if (state.status == ProductSearchStatus.loading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: LoadingView(),
                  );
                } else {
                  return const LibraryView();
                }
              },
            ),
          ),
          bottomNavigationBar: const SizedBox(),
        ),
      ),
    );
  }
}

class SessionsSearchView extends StatelessWidget {
  const SessionsSearchView({
    Key? key,
    required this.products,
    required this.packs,
    required this.filter,
  }) : super(key: key);

  final List<Product> products;
  final List<ProductPack> packs;
  final String filter;

  @override
  Widget build(BuildContext context) {
    if (products.isNotEmpty || packs.isNotEmpty) {
      return SingleChildScrollView(child: buildContentWidget(context));
    } else {
      return buildEmptyWidget(context);
    }
  }

  Widget buildContentWidget(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: ComponentColors.defaultBodyTextColor);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Search results',
                style: style?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ProductsListView(
            pack: ProductPack(
              'search_results',
              'Search results',
              DateTime.now(),
              products,
              DownloadProductType.audio,
            ),
            playlist: null,
          ),
          if (products.isNotEmpty) const SizedBox(height: 24),
          ListView.separated(
            itemCount: packs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final pack = packs[index];

              switch (pack.type) {
                case DownloadProductType.audio:
                  return YourAudioPackLisViewItem(
                    yourAudioPack: pack,
                    onTap: () => pushPackDetailsPage(
                      context,
                      pack.type,
                      pack,
                    ),
                  );
                case DownloadProductType.script:
                  return YourScriptsPackListViewItem(
                    yourScriptPack: pack,
                    onTap: () => pushPackDetailsPage(
                      context,
                      pack.type,
                      pack,
                    ),
                  );
                case DownloadProductType.audioWithScript:
                  return YourAudioPackLisViewItem(
                    yourAudioPack: pack,
                    onTap: () => pushPackDetailsPage(
                      context,
                      pack.type,
                      pack,
                    ),
                  );
              }
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyWidget(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: ComponentColors.defaultBodyTextColor);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: style,
            children: [
              TextSpan(
                text: filter,
                style: style?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: ' not found',
                style: style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
