import 'dart:async';

import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/home/home_page.dart';
import 'package:hypnosis_downloads/app/splash/intro_page.dart';
import 'package:hypnosis_downloads/app/view/components/app_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  static Page<void> get page => const MaterialPage<void>(child: SplashPage());

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const SplashPage());

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool visible = false;

  @override
  void initState() {
    unawaited(context.read<CurrentUserCubit>().onPageOpened());
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        visible = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      final currentUserCubit = context.read<CurrentUserCubit>();
      if (currentUserCubit.state is Authenticated) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder<void>(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const HomePage(),
          ),
        );
      } else if (context.read<CurrentUserCubit>().state is Unauthenticated) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder<void>(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const IntroPage(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color
      statusBarIconBrightness: Brightness.dark, // Set status bar icons color
    ));
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: visible ? 1.0 : 0.0,
          curve: Curves.easeIn,
          child: const AppLogoWithText(),
        ),
      ),
    );
  }
}
