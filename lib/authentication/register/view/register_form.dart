import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/ui_views_states.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_input_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool remember = true;
  String? error;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterWithEmailPasswordCubit, AuthRegisterState>(
      listener: (context, state) {
        if (state is AuthRegisterFailure) {
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
                error: error,
              ),
              const SizedBox(height: 16),
              _NameInput(
                hintText: 'First name',
                controller: _firstNameController,
              ),
              const SizedBox(height: 16),
              _NameInput(
                hintText: 'Last name',
                controller: _lastNameController,
              ),
              const SizedBox(height: 16),
              _PasswordInput(
                hintText: 'Password',
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              _PasswordInput(
                hintText: 'Confirm password',
                controller: _confirmPasswordController,
              ),
            ],
          ),
          BlocBuilder<RegisterWithEmailPasswordCubit, AuthRegisterState>(
            builder: (context, state) {
              if (state is AuthRegisterFailure) {
                return ErrorView(state.errorMessage);
              } else {
                return const SizedBox(height: 32);
              }
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                'Create',
                onTap: () {
                  setState(() {
                    final email = _emailController.text;
                    if (context
                        .read<RegisterWithEmailPasswordCubit>()
                        .isEmailValid(email)) {
                      error = null;
                      TextInput.finishAutofillContext(shouldSave: true);
                      context
                          .read<RegisterWithEmailPasswordCubit>()
                          .registerWithEmailPassword(
                            _emailController.text,
                            _passwordController.text,
                            _confirmPasswordController.text,
                            _firstNameController.text,
                            _lastNameController.text,
                          );
                    } else {
                      error = 'Please enter a valid email address';
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key, required this.controller, required this.error})
      : super(key: key);

  final TextEditingController controller;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithEmailPasswordCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          controller.clear();
        }
      },
      child: DefaultInputField(
        hintText: 'Email',
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        errorText: error,
        autofillHints: const [AutofillHints.email],
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({Key? key, required this.hintText, required this.controller})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithEmailPasswordCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          controller.clear();
        }
      },
      child: DefaultInputField(
        hintText: hintText,
        controller: controller,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        autofillHints: const [AutofillHints.name],
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput(
      {Key? key, required this.hintText, required this.controller})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginWithEmailPasswordCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          controller.clear();
        }
      },
      child: DefaultInputField(
        hintText: hintText,
        controller: controller,
        obscureText: true,
        autofillHints: const [AutofillHints.password],
      ),
    );
  }
}
