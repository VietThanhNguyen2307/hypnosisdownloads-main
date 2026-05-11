import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/group_tab.dart';
import 'package:hypnosis_downloads/library/quick_breaks/quick_breaks_view.dart';
import 'package:hypnosis_downloads/products/audios/view/audios_view.dart';
import 'package:hypnosis_downloads/products/scripts/view/scripts_view.dart';
import 'package:hypnosis_downloads/library/view/components/latest_news/view/latest_news_widget.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: quickBreaksMode,
      builder: (context, isQuickBreaksMode, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: (isQuickBreaksMode as bool)
              ? const QuickBreaksView()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const LatestNewsWidget(),
                      GroupTab(
                        items: const ['Audios', 'Scripts'],
                        onChange: (index) {
                          setState(() {
                            activeIndex = index;
                          });
                        },
                      ),
                      IndexedStack(
                        index: activeIndex,
                        children: const [
                          AudiosView(),
                          ScriptsView(),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
