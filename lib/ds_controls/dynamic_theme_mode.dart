import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicThemeMode extends StatefulWidget {
  final Widget child;
  final ThemeMode defaultThemeMode;

  const DynamicThemeMode({
    Key key,
    this.child,
    this.defaultThemeMode = ThemeMode.system,
  }) : super(key: key);

  @override
  DynamicThemeModeState createState() => DynamicThemeModeState();

  static DynamicThemeModeState of(BuildContext context) {
    return context.findAncestorStateOfType<DynamicThemeModeState>();
  }
}

class DynamicThemeModeState extends State<DynamicThemeMode> {
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('themeMode');
    setState(() {
      if (themeModeIndex != null && themeModeIndex < ThemeMode.values.length) {
        _themeMode = ThemeMode.values[themeModeIndex];
      } else {
        _themeMode = widget.defaultThemeMode;
      }
    });
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    setState(() {
      _themeMode = themeMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: this,
      child: widget.child,
    );
  }
}
