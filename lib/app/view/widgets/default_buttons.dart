import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';
import 'package:hypnosis_downloads/app/view/common/shadows.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.data, {
    Key? key,
    this.onTap,
    this.enabled = true,
  })  : _icon = null,
        super(key: key);

  const PrimaryButton.icon(
    this.data, {
    Key? key,
    this.onTap,
    this.enabled = true,
    required Widget icon,
  })  : _icon = icon,
        super(key: key);

  final String data;
  final VoidCallback? onTap;
  final bool enabled;

  final Widget? _icon;

  static final _bordeRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: !enabled,
      child: InkWell(
        onTap: onTap,
        borderRadius: _bordeRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: enabled
                ? ComponentColors.primaryButtonColor
                : ComponentColors.primaryButtonDisabledColor,
            borderRadius: _bordeRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_icon != null) ...[
                _icon ?? Container(),
                const SizedBox(width: 8),
              ],
              Text(
                data,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: ComponentColors.primaryButtonTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
    this.data, {
    Key? key,
    this.onTap,
  })  : _icon = null,
        super(key: key);

  const SecondaryButton.icon(
    this.data, {
    Key? key,
    this.onTap,
    required Widget icon,
  })  : _icon = icon,
        super(key: key);

  final String data;
  final VoidCallback? onTap;

  final Widget? _icon;

  static final _bordeRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: _bordeRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: ComponentColors.secondaryButtonColor,
          borderRadius: _bordeRadius,
          boxShadow: [Shadows.card],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_icon != null) ...[
              _icon ?? Container(),
              const SizedBox(width: 8),
            ],
            Text(
              data,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: ComponentColors.defaultBodyTextColor),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdButton extends StatelessWidget {
  const ThirdButton(
    this.data, {
    Key? key,
    this.onTap,
  })  : _icon = null,
        super(key: key);

  const ThirdButton.icon(
    this.data, {
    Key? key,
    this.onTap,
    required Widget icon,
  })  : _icon = icon,
        super(key: key);

  final String data;
  final VoidCallback? onTap;

  final Widget? _icon;

  static final _bordeRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: _bordeRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: ComponentColors.thirdButtonColor,
          borderRadius: _bordeRadius,
          boxShadow: [Shadows.card],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_icon != null) ...[
              _icon ?? Container(),
              const SizedBox(width: 8),
            ],
            Text(
              data,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: ComponentColors.primaryButtonTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
