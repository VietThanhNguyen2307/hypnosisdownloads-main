// ignore_for_file: avoid_field_initializers_in_const_classes

import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class HeadlineText extends StatelessWidget {
  const HeadlineText(this.data, {Key? key, Color? color, this.textAlign})
      : _color = color ?? ComponentColors.defaultHeadlineTextColor,
        super(key: key);

  const HeadlineText.light(this.data, {Key? key, this.textAlign})
      : _color = ComponentColors.defaultHeadlineTextColor,
        super(key: key);

  const HeadlineText.dark(this.data, {Key? key, this.textAlign})
      : _color = ComponentColors.secondaryHeadlineTextColor,
        super(key: key);

  final String data;
  final Color _color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(color: _color),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
