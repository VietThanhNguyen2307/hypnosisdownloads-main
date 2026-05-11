import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hypnosis_downloads/app/view/common/assets.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/widgets/default_icon_button.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({Key? key, this.onTap, this.playing = false})
      : super(key: key);

  final VoidCallback? onTap;
  final bool playing;

  static final _borderRadius = BorderRadius.circular(36);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap?.call();
      },
      child: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ComponentColors.primaryButtonColor,
          borderRadius: PlayButton._borderRadius,
        ),
        child: getIcon(),
      ),
    );
  }

  Widget getIcon() {
    if (widget.playing) {
      return SvgPicture.asset(
        key: const Key('Pause'),
        IconsBold.pause,
        color: Colors.white,
      );
    } else {
      return SvgPicture.asset(
        key: const Key('Play'),
        IconsBold.play,
        color: Colors.white,
      );
    }
  }
}

class SmallPlayButton extends StatefulWidget {
  const SmallPlayButton({
    Key? key,
    this.playing = false,
    this.onTap,
  }) : super(key: key);

  final bool playing;
  final VoidCallback? onTap;

  @override
  State<SmallPlayButton> createState() => _SmallPlayButtonState();
}

class _SmallPlayButtonState extends State<SmallPlayButton> {
  @override
  Widget build(BuildContext context) {
    return DefaultIconButton(
      SvgPicture.asset(
        getIcon(),
        color: Colors.white,
        height: 16,
        width: 16,
      ),
      onTap: () {
        widget.onTap?.call();
      },
    );
  }

  String getIcon() {
    if (widget.playing) {
      return IconsBold.pause;
    }
    return IconsBold.play;
  }
}
