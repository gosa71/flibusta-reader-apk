import 'dart:io';

import 'package:flutter/services.dart';

class NativeMethods {
  static const _platform = const MethodChannel('ru.utopicnarwhal.flibustabrowser/native_methods_channel');

  static Future<void> rescanFolder(String dir) async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await _platform.invokeMethod('rescan_folder', dir);
      print("Сканирование успешно завершено");
    } on PlatformException catch (e) {
      print("Сканирование не удалось. Ошибка: " + e.toString());
    }
  }

  /// Держит экран включённым, пока читается книга.
  static Future<void> setKeepScreenOn(bool keepOn) async {
    if (!Platform.isAndroid) return;
    try {
      await _platform.invokeMethod('keep_screen_on', keepOn);
    } on PlatformException catch (e) {
      print("setKeepScreenOn failed: " + e.toString());
    }
  }

  /// value: -1.0 — системная яркость, 0.0..1.0 — переопределить для окна читалки.
  static Future<void> setBrightness(double value) async {
    if (!Platform.isAndroid) return;
    try {
      await _platform.invokeMethod('set_brightness', value);
    } on PlatformException catch (e) {
      print("setBrightness failed: " + e.toString());
    }
  }

  /// Показать/скрыть системный UI (status bar + navigation bar).
  static Future<void> setSystemUIVisible(bool visible) async {
    if (!Platform.isAndroid) return;
    try {
      await SystemChrome.setEnabledSystemUIOverlays(
        visible
            ? SystemUiOverlay.values
            : <SystemUiOverlay>[],
      );
    } catch (e) {
      print("setSystemUIVisible failed: " + e.toString());
    }
  }
}
