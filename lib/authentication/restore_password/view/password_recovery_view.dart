// ignore_for_file: lines_longer_than_80_chars

import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/app_logo.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_input_field.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button.dart';

class PasswordRecoveryView extends StatefulWidget {
  const PasswordRecoveryView(this._emailController, {Key? key})
      : super(key: key);

  final TextEditingController _emailController;

  @override
  State<PasswordRecoveryView> createState() => _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends State<PasswordRecoveryView> {
  String? error;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16) + const EdgeInsets.only(top: 34),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const AppLogoWithText(),
                const SizedBox(height: 29),
                const BodyMediumText(
                  'Enter the email address associated with your Hypnosis Downloads account so we can send an email to reset your password:',
                ),
                const SizedBox(height: 24),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultInputField(
                      hintText: 'Email address',
                      controller: widget._emailController,
                    ),
                    SizedBox(
                      height: 32,
                      child: Center(
                        child: BodyMediumText.error(error ?? ''),
                      ),
                    ),
                    PrimaryButton(
                      'Reset my password',
                      onTap: () {
                        final email = widget._emailController.text;
                        if (context
                            .read<RegisterWithEmailPasswordCubit>()
                            .isEmailValid(email)) {
                          context
                              .read<RestorePasswordCubit>()
                              .restorePasswordVia(email);
                        } else {
                          setState(() {
                            error = 'Please enter a valid email address';
                          });
                        }
                      },
                    ),
                  ],
                ),
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
    );
  }
}
