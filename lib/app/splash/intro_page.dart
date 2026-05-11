import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/splash/privacy_policy.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/components/app_logo.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_buttons.dart';
import 'package:hypnosis_downloads/authentication/login_with_email_password/view/login_page.dart';
import 'package:hypnosis_downloads/authentication/register/view/register_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  static Page<void> get page => const MaterialPage<void>(child: IntroPage());

  static MaterialPageRoute<dynamic> get route =>
      MaterialPageRoute(builder: (context) => const IntroPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: IntroView(),
    );
  }
}

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.padding.bottom;

    return ColoredBox(
      color: ComponentColors.backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset > 0 ? 8 : 16),
          child: Column(
            children: [
              const SizedBox(
                height: 48,
                child: AppLogoWithText(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Try a full Uncommon\nHypnosis session FREE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 44,
                  height: 1.15,
                  color: ComponentColors.secondaryHeadlineTextColor,
                ),
              ),
              const SizedBox(height: 20),
              const IntroVideoWidget(),
              const SizedBox(height: 24),
              const Text(
                "Get the 'First Time Hypnosis' session\nfree (usually \$14.95) when you\ncreate your free account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: ComponentColors.defaultBodyTextColor,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                'Create my free account',
                onTap: () => Navigator.of(context).push(RegisterPage.route),
              ),
              const SizedBox(height: 10),
              _LoginLinkText(
                onLoginTap: () => Navigator.of(context).pushReplacement(
                  PageRouteBuilder<void>(
                    transitionDuration: const Duration(milliseconds: 800),
                    pageBuilder: (_, __, ___) => const LoginPage(),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                '©2026 Uncommon Knowledge Ltd, Boswell House, Argyll Square, Oban,\nUK PA34 4BD. Registered Company 03573107',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: ComponentColors.defaultLabelTextColor,
                  height: 1.4,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).push(PrivacyPolicyPage.route),
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 22,
                    color: ComponentColors.defaultTextButtonColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginLinkText extends StatelessWidget {
  const _LoginLinkText({
    required this.onLoginTap,
  });

  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: ComponentColors.defaultBodyTextColor,
        ),
        children: [
          const TextSpan(text: 'Already got an account? '),
          TextSpan(
            text: 'Login here',
            style: const TextStyle(
              color: Color(0xFFED8B24),
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLoginTap,
          ),
        ],
      ),
    );
  }
}

class IntroVideoWidget extends StatefulWidget {
  const IntroVideoWidget({super.key});

  @override
  State<IntroVideoWidget> createState() => _IntroVideoWidgetState();
}

class _IntroVideoWidgetState extends State<IntroVideoWidget> {
  late YoutubePlayerController _controller;

  bool visiblePlaceholder = true;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: 'jVrudNg5ju4',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        hideThumbnail: true,
      ),
    );
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          YoutubePlayer(
            controller: _controller,
            width: MediaQuery.of(context).size.width - 32,
          ),
          SizedBox.square(
            dimension: MediaQuery.of(context).size.width - 32,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: visiblePlaceholder ? _buildPlaceholder() : null,
            ),
          ),
        ],
      ),
    );
  }

  _buildPlaceholder() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Assets.youtubeImagePlaceholder,
          fit: BoxFit.contain,
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _controller.play();
            setState(() {
              visiblePlaceholder = false;
            });
          },
          child: SizedBox.square(
            dimension: 64,
            child: SvgPicture.asset(
              IconsBold.play,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        )
      ],
    );
  }
}
