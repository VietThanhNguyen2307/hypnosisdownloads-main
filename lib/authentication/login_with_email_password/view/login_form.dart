import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_input_field.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_switch.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_text_button.dart';
import 'package:hypnosis_downloads/authentication/register/view/register_page.dart';
import 'package:hypnosis_downloads/authentication/restore_password/view/password_recovery_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _remember = true;
  TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadEmail();
  }

  Future<void> loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String email = prefs.getString('email') ?? '';
      _emailController = TextEditingController(text: email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithEmailPasswordCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Padding(
                padding: const EdgeInsets.all(12),
                child: IntrinsicHeight(
                  child: Center(
                    child: Text(
                      state.errorMessage,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: ComponentColors.snackBarTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EmailInput(
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              _PasswordInput(
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BodyMediumText('Remember me'),
                  DefaultSwitch(
                    value: _remember,
                    onToggle: (value) {
                      setState(() {
                        _remember = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                'Login',
                onTap: () {
                  context
                      .read<LoginWithEmailPasswordCubit>()
                      .loginWithEmailPassword(
                        _emailController.text,
                        _passwordController.text,
                        _remember,
                      );
                },
              ),
              const SizedBox(height: 16),
              DefaultTextButton(
                'Sign up',
                onPressed: () {
                  TextInput.finishAutofillContext(shouldSave: true);
                  Navigator.of(context).push(RegisterPage.route);
                },
              ),
              const SizedBox(height: 8),
              DefaultTextButton(
                'Forgotten your password?',
                onPressed: () =>
                    Navigator.of(context).push(PasswordRecoveryPage.route),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithEmailPasswordCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          controller.clear();
        }
      },
      child: DefaultInputField(
        hintText: 'Email',
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithEmailPasswordCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          controller.clear();
        }
      },
      child: DefaultInputField(
        hintText: 'Password',
        controller: controller,
        obscureText: true,
        autofillHints: const [AutofillHints.password],
      ),
    );
  }
}
