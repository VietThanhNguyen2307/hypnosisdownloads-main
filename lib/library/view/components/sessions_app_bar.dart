import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/gradients.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/app/view/components/search_text_form_field.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/search/product_search/product_search_bloc.dart';
import 'package:provider/provider.dart';

class SessionsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SessionsAppBar({Key? key}) : super(key: key);

  @override
  State<SessionsAppBar> createState() => _SessionsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(148);
}

class _SessionsAppBarState extends State<SessionsAppBar> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        gradient: Gradients.primaryGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar.primary(
            title: 'My Sessions ',
            backgroundColor: Colors.transparent,
            titleColor: Colors.white,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeadlineMediumText(
                  'Search my purchases',
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                SearchTextFormField(
                  controller: controller,
                  onChanged: (value) =>
                      context.read<ProductSearchBloc>().changeFilter(value),
                  onClear: () => context.read<ProductSearchBloc>().clear(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
