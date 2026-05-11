import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class DefaultSwitch extends StatelessWidget {
  const DefaultSwitch({
    Key? key,
    required this.value,
    required this.onToggle,
  })  : _width = 60,
        _height = 32,
        _toggleSize = 28,
        _padding = 2,
        super(key: key);

  const DefaultSwitch.small({
    Key? key,
    required this.value,
    required this.onToggle,
  })  : _width = 30,
        _height = 16,
        _toggleSize = 14,
        _padding = 1,
        super(key: key);

  final bool value;
  final void Function(bool) onToggle;

  final double _width;
  final double _height;
  final double _toggleSize;
  final double _padding;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      value: value,
      onToggle: onToggle,
      width: _width,
      height: _height,
      activeColor: ComponentColors.defaultSwitchActiveColor,
      inactiveColor: ComponentColors.defaultSwitchInactiveColor,
      inactiveSwitchBorder: Border.all(
        color: ComponentColors.defaultSwitchInactiveBorderColor,
      ),
      inactiveToggleColor: ComponentColors.defaultSwitchInactiveToggleColor,
      borderRadius: 32,
      toggleSize: _toggleSize,
      padding: _padding,
      inactiveToggleBorder: Border.all(
        color: ComponentColors.defaultSwitchInactiveToggleColor,
      ),
    );
  }
}
