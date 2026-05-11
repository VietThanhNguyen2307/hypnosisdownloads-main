// ignore_for_file: avoid_field_initializers_in_const_classes

import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class LabelText extends StatelessWidget {
  const LabelText(this.data, {Key? key})
      : _color = ComponentColors.defaultLabelTextColor,
        super(key: key);

  const LabelText.dark(this.data, {Key? key})
      : _color = ComponentColors.defaultBodyTextColor,
        super(key: key);

  final String data;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _color),
      textAlign: TextAlign.center,
    );
  }
}
