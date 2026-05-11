import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypnosis_downloads/app/view/common/colors.dart';

final _primarySwatch = _createMaterialColor(ComponentColors.primaryColor);

/// Applicaliton ligh theme
final lightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.comfortable,
  primaryColor: ComponentColors.primaryColor,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  scaffoldBackgroundColor: ComponentColors.backgroundColor,
  fontFamily: 'Open Sans',
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: ComponentColors.inputBorderColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: ComponentColors.disabledBorderColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: ComponentColors.enabledBorderColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: ComponentColors.errorBorderColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: ComponentColors.enabledBorderColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: ComponentColors.errorBorderColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    hintStyle: const TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 20.0 / 14.0,
      color: ComponentColors.hintTextColor,
    ),
    contentPadding: const EdgeInsets.fromLTRB(16, 12, 10, 12),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      height: 28.0 / 20.0,
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 24.0 / 16.0,
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      height: 20.0 / 14.0,
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 24.0 / 16.0,
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 20.0 / 14.0,
    ),
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      height: 14.0 / 10.0,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 24.0 / 16.0,
    ),
    labelSmall: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 11,
      height: 15 / 11,
    ),
  ).apply(
    bodyColor: ComponentColors.defaultTextColor,
    displayColor: ComponentColors.defaultTextColor,
  ), colorScheme: ColorScheme.fromSwatch(primarySwatch: _primarySwatch).copyWith(background: ComponentColors.backgroundColor),
);

/// Applicaliton dark theme, currently don'y uses
final darkTheme = lightTheme.copyWith();

MaterialColor _createMaterialColor(Color color) {
  final strengths = <double>[.05];
  final swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final strength in strengths) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
