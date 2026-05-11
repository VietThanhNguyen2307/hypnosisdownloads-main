import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/authentication/login_with_email_password/view/login_page.dart';

class AccountDeletedScreen extends StatelessWidget {
  static MaterialPageRoute<dynamic> get route => MaterialPageRoute(
        builder: (context) => const AccountDeletedScreen(),
      );

  const AccountDeletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "Please check your email to confirm account deletion",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const BodyMediumText(
                  "We’re sorry to see you go. You will receive a confirmation email in your inbox in the next 24-48 hours to permanently delete your account.\n\nYour account is now logged out of this device.",
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  'Return to Home',
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      LoginPage.route,
                      (route) => false,
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
