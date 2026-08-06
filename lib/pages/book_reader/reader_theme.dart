import 'package:flutter/material.dart';

class ReaderThemeData {
  final String name;
  final Color backgroundColor;
  final Color textColor;
  final Color secondaryTextColor;
  final Color linkColor;
  final Color appBarColor;
  final Brightness statusBarBrightness;

  const ReaderThemeData({
    this.name,
    this.backgroundColor,
    this.textColor,
    this.secondaryTextColor,
    this.linkColor,
    this.appBarColor,
    this.statusBarBrightness,
  });
}

const kReaderThemes = <ReaderThemeData>[
  ReaderThemeData(
    name: 'День',
    backgroundColor: Color(0xFFFBF7EF),
    textColor: Color(0xFF262220),
    secondaryTextColor: Color(0xFF8A7F72),
    linkColor: Color(0xFFAD6A2B),
    appBarColor: Color(0xFFF3EDE1),
    statusBarBrightness: Brightness.light,
  ),
  ReaderThemeData(
    name: 'Ночь',
    backgroundColor: Color(0xFF17181C),
    textColor: Color(0xFFCACDD2),
    secondaryTextColor: Color(0xFF75787E),
    linkColor: Color(0xFF6FA8DC),
    appBarColor: Color(0xFF101114),
    statusBarBrightness: Brightness.dark,
  ),
];
