import 'package:flutter/material.dart';

const double kBottomSheetBorderRadius = 4.0;

ThemeData buildLightTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    fontFamily: 'Inter',
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

// aliases used by some files
final kLightTheme = buildLightTheme();
final kDarkTheme = buildDarkTheme();
