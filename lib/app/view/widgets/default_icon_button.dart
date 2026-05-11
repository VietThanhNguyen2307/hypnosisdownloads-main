import 'package:flutter/material.dart';

class DefaultIconButton extends StatelessWidget {
  const DefaultIconButton(
    this.icon, {
    Key? key,
    this.onTap,
    this.isEnabled = true,
    double? dimension = 26,
  })  : _dimension = dimension,
        super(key: key);

  const DefaultIconButton.regular(
    this.icon, {
    super.key,
    this.onTap,
    this.isEnabled = true,
  })  : _dimension = 30;

  const DefaultIconButton.large(
    this.icon, {
    super.key,
    this.onTap,
    this.isEnabled = true,
  })  : _dimension = 34;

  const DefaultIconButton.largest(
    this.icon, {
    super.key,
    this.onTap,
    this.isEnabled = true,
  })  : _dimension = 40;

  final Widget icon;
  final VoidCallback? onTap;
  final bool isEnabled;

  final double? _dimension;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: SizedBox.square(
        dimension: _dimension,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Opacity(
            opacity: isEnabled ? 1 : 0.25,
            child: icon,
          ),
        ),
      ),
    );
  }
}
