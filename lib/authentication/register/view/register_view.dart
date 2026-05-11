// ignore_for_file: lines_longer_than_80_chars

import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/app_logo.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button.dart';
import 'package:hypnosis_downloads/authentication/register/view/register_form.dart';

class RegisterView extends StatefulWidget {
  const RegisterView(this._emailController, {Key? key}) : super(key: key);

  final TextEditingController _emailController;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16) + const EdgeInsets.only(top: 34),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                children: [
                  AppLogoWithText(),
                  SizedBox(height: 29),
                  BodyMediumText(
                    'Create your free account',
                  ),
                  SizedBox(height: 24),
                  RegisterForm()
                ],
              ),
              DefaultTextButton(
                'Go back to the login page',
                onPressed: () {
                  context.read<RestorePasswordCubit>().onBackPressed();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
