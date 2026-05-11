import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/headline_medium_text.dart';
import 'package:hypnosis_downloads/app/view/components/text/label_text.dart';
import 'package:hypnosis_downloads/library/view/components/latest_news/logic/latest_news_cubit.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LatestNewsWidget extends StatelessWidget {
  const LatestNewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LatestNewsCubit, LatestNewsState>(
      builder: (context, state) {
        if (state is LatestNewsLoadSuccess) {
          final latestNewsItem = state.latestNewsItem;
          DateTime dateTime = latestNewsItem.timestamp.toDate();
          String formattedDate = DateFormat.yMMMMd('en_US').format(dateTime);
          return Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeadlineMediumText.dark('Latest news'),
                const SizedBox(height: 4),
                LabelText(formattedDate),
                const SizedBox(height: 2),
                Html(
                  data: latestNewsItem.text,
                  onLinkTap: (url, attributes, element) async {
                    if (url == null) return;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      launchUrl(Uri.parse(url));
                    }
                  },
                  style: {
                    "body": Style(
                      margin: Margins.all(0),
                    ),
                    'a': Style(
                      color: ComponentColors.primaryColor,
                      textDecoration: TextDecoration.none,
                    ),
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
