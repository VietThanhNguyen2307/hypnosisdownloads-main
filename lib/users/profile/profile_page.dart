import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypnosis_downloads/app/view/components/custom_app_bar.dart';
import 'package:hypnosis_downloads/users/profile/view/profile_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static Page<void> get page => const MaterialPage<void>(child: ProfilePage());

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const ProfilePage());

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: CustomAppBar.primary(title: 'Profile'),
        body: SafeArea(child: ProfileView()),
        bottomNavigationBar: SizedBox(),
      ),
    );
  }
}
