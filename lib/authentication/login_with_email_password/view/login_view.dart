import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/app_logo.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/authentication/login_with_email_password/view/login_form.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16) + const EdgeInsets.only(top: 34),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              AppLogoWithText(),
              SizedBox(height: 29),
              BodyMediumText(
                'Login below to access your\n Hypnosis Downloads',
              ),
              SizedBox(height: 24),
              LoginForm()
              // buildForm(),
            ],
          ),
        ),
      ),
    );
  }
}
