import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/home/home_page.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/authentication/login_with_email_password/view/login_view.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page<void> get page => const MaterialPage<void>(child: LoginPage());

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const LoginPage());

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithEmailPasswordCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            HomePage.route,
            (route) => false,
          );
        }
        if (state is AuthInProgress) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
      child: const CustomLoaderOverlay(
        child: Scaffold(body: LoginView()),
      ),
    );
  }
}
