// ignore_for_file: avoid_field_initializers_in_const_classes

import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class BodyMediumText extends StatelessWidget {
  const BodyMediumText(
    this.data, {
    Key? key,
    Color? color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
  })  : _color = color ?? ComponentColors.defaultBodyTextColor,
        super(key: key);

  const BodyMediumText.dark(
    this.data, {
    Key? key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
  })  : _color = ComponentColors.titleBodyTextColor,
        super(key: key);

  const BodyMediumText.error(
    this.data, {
    Key? key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
  })  : _color = ComponentColors.errorTextColor,
        super(key: key);

  const BodyMediumText.light(
    this.data, {
    Key? key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
  })  : _color = ComponentColors.defaultLabelTextColor,
        super(key: key);

  const BodyMediumText.white(
    this.data, {
    Key? key,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
  })  : _color = Colors.white,
        super(key: key);

  final String data;
  final Color _color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _color),
      textAlign: textAlign ?? TextAlign.center,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }
}
