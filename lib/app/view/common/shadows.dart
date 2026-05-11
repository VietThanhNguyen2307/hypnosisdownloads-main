import 'package:flutter/material.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

class Shadows {
  static final card = BoxShadow(
    color: ComponentColors.primaryShadowColor.withOpacity(.12),
    blurRadius: 16,
  );

  static final navbar = BoxShadow(
    color: ComponentColors.primaryShadowColor.withOpacity(.14),
    offset: const Offset(0, -8),
    blurRadius: 24,
    spreadRadius: 24,
  );

  static final groupPin = BoxShadow(
    color: ComponentColors.primaryShadowColor.withOpacity(.12),
    blurRadius: 16,
    spreadRadius: 16,
  );
}
