import 'package:authentication_logic/authentication_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/custom_loader_overlay.dart';
import 'package:hypnosis_downloads/authentication/restore_password/view/password_recovery_resend_view.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PasswordRecoveryResendPage extends StatelessWidget {
  const PasswordRecoveryResendPage(this.email, {Key? key}) : super(key: key);

  final String email;

  static MaterialPageRoute<dynamic> route(String email) => MaterialPageRoute(
        builder: (context) => PasswordRecoveryResendPage(email),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestorePasswordCubit, RestorePasswordState>(
      listener: (context, state) {
        if (state is RequestVerificationFailure) {
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

        if (state is RequestVerificationInProgress) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      },
      child: CustomLoaderOverlay(
        child: Scaffold(
          body: PasswordRecoveryResendView(email),
        ),
      ),
    );
  }
}
