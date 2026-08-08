import 'package:flutter/material.dart';

const double kBottomSheetBorderRadius = 4.0;

ThemeData buildLightTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    fontFamily: 'Inter',
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
  );
}
