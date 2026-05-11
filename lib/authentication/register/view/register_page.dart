
import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/home/home_page.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/authentication/register/view/register_view.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const RegisterPage());

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterWithEmailPasswordCubit, AuthRegisterState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            HomePage.route,
            (route) => false,
          );
        }
        if (state is AuthRegisterInProgress) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
      child: CustomLoaderOverlay(
        child: Scaffold(
          body: RegisterView(_emailController),
        ),
      ),
    );
  }
}
