import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class DefaultTextButtonSmall extends StatelessWidget {
  const DefaultTextButtonSmall(
    this.data, {
    Key? key,
    this.onPressed,
  })  : _icon = null,
        super(key: key);

  const DefaultTextButtonSmall.icon(
    this.data, {
    Key? key,
    this.onPressed,
    Widget? icon,
  })  : _icon = icon,
        super(key: key);

  final String data;
  final void Function()? onPressed;
  final Widget? _icon;

  @override
  Widget build(BuildContext context) {
    return _icon != null
        ? TextButton.icon(
            onPressed: onPressed,
            icon: SizedBox.square(
              dimension: 16,
              child: _icon ?? Container(),
            ),
            label: Text(
              data,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ComponentColors.labelTextColor,
                  ),
            ),
          )
        : TextButton(
            onPressed: onPressed,
            child: Text(
              data,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ComponentColors.labelTextColor,
                  ),
            ),
          );
  }
}
