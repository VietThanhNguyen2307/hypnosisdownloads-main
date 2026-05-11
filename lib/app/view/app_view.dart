import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypnosis_downloads/app/home/routes/navigation_service.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/theme.dart';

class AppView extends StatelessWidget {
  const AppView({
    required this.initialPage,
    super.key,
  });

  final Widget initialPage;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color
      statusBarIconBrightness: Brightness.dark,
    ));
    precacheImage(
      const AssetImage(Assets.youtubeImagePlaceholder),
      context,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      navigatorKey: NavigationService.navigatorKey,
      home: initialPage,
    );
  }
}
