import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/text/body_medium_text.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';
import 'package:hypnosis_downloads/users/delete_account/please_confirm_screen.dart';

class DeleteAccountScreen extends StatelessWidget {
  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const DeleteAccountScreen());
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  DefaultIconButton(
                    SvgPicture.asset(Assets.shortArrowLeft),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 8),
                  const BodyMediumText(
                    "Back",
                    color: ComponentColors.titleBodyTextColor,
                  )
                ],
              ),
              const Spacer(flex: 3),
              Flexible(
                flex: 5,
                child: Column(
                  children: [
                    const Text(
                      "Are you sure you want to delete your account?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Warning:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            TextSpan(
                              text:
                                  ' deleting your account will remove access to all your purchased products from Hypnosis Downloads',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      'No, take me back',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 24),
                    ThirdButton(
                      'Yes, delete my account',
                      onTap: () {
                        Navigator.push(
                          context,
                          PleaseConfirmScreen.route,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
