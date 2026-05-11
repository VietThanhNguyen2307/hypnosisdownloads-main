import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class DefaultTextButton extends StatelessWidget {
  const DefaultTextButton(
    this.data, {
    Key? key,
    this.onPressed,
    this.style,
  })  : _icon = null,
        super(key: key);

  const DefaultTextButton.icon(
    this.data, {
    Key? key,
    this.onPressed,
    Widget? icon,
    this.style,
  })  : _icon = icon,
        super(key: key);

  final String data;
  final void Function()? onPressed;
  final Widget? _icon;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return _icon != null
        ? TextButton.icon(
            onPressed: onPressed,
            icon: _icon ?? Container(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.center,
              minimumSize: Size.zero,
              splashFactory: NoSplash.splashFactory,
            ),
            label: Text(
              data,
              style: style ??
                  Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: ComponentColors.defaultTextButtonColor,
                      ),
            ),
          )
        : TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.center,
              minimumSize: Size.zero,
              splashFactory: NoSplash.splashFactory,
            ),
            child: Text(
              data,
              style: style ??
                  Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: ComponentColors.defaultTextButtonColor,
                      ),
            ),
          );
  }
}
