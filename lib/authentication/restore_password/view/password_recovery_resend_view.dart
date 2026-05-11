// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/components/app_logo.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button.dart';

class PasswordRecoveryResendView extends StatefulWidget {
  const PasswordRecoveryResendView(this.email, {Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryResendView> createState() =>
      _PasswordRecoveryResendViewState();

  final String email;
}

class _PasswordRecoveryResendViewState
    extends State<PasswordRecoveryResendView> {
  late Timer _timer;
  int _start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start <= 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
                  'You have been sent an email with a new\n password. Login using the new password',
                ),
                const SizedBox(height: 80),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BodyMediumText('The email has not arrived?'),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      'Resend${_timer.isActive ? ' 0:${_start.toString().padLeft(2, "0")}' : ''}',
                      enabled: !_timer.isActive,
                      onTap: () => context
                          .read<RestorePasswordCubit>()
                          .restorePasswordVia(widget.email),
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
