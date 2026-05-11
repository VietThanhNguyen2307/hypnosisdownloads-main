import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/library/quick_breaks/quick_breaks_list.dart';

final quickBreaksMode = ValueNotifier<bool>(false);

class QuickBreaksView extends StatelessWidget {
  const QuickBreaksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultIconButton(
          Icon(Icons.arrow_back),
          onTap: () => quickBreaksMode.value = false,
        ),
        const SizedBox(height: 16),
        HeadlineMediumText.dark('Quick Breaks'),
        const SizedBox(height: 16),
        Expanded(child: QuickBreaksList()),
      ],
    );
  }
}
