import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<void> checkVersion() async {}

  Future<String> getActualProxy() async {
    final p = await _prefs;
    return p.getString('actual_proxy') ?? '';
  }

  Future<void> setActualProxy(String proxy) async {
    final p = await _prefs;
    await p.setString('actual_proxy', proxy);
  }

  Future<String> getHostAddress() async {
    final p = await _prefs;
    return p.getString('host_address') ?? 'http://flibusta.is';
  }

  Future<void> setHostAddress(String url) async {
    final p = await _prefs;
    await p.setString('host_address', url);
  }

  Future<Directory> getBooksDirectory() async {
    final p = await _prefs;
    final path = p.getString('books_directory');
    if (path != null) return Directory(path);
    final dir = await getExternalStorageDirectory();
    return Directory('${dir.path}/FlibustaBooks');
  }

  Future<void> setBooksDirectory(Directory dir) async {
    final p = await _prefs;
    await p.setString('books_directory', dir.path);
  }

  // Reader settings
  Future<double> getReaderFontSize() async {
    final p = await _prefs;
    return p.getDouble('reader_font_size');
  }

  Future<void> setReaderFontSize(double v) async {
    final p = await _prefs;
    await p.setDouble('reader_font_size', v);
  }

  Future<int> getReaderThemeIndex() async {
    final p = await _prefs;
    return p.getInt('reader_theme_index');
  }

  Future<void> setReaderThemeIndex(int v) async {
    final p = await _prefs;
    await p.setInt('reader_theme_index', v);
  }

  Future<double> getReaderBrightness() async {
    final p = await _prefs;
    return p.getDouble('reader_brightness');
  }

  Future<void> setReaderBrightness(double v) async {
    final p = await _prefs;
    await p.setDouble('reader_brightness', v);
  }

  Future<double> getReaderMargin() async {
    final p = await _prefs;
    return p.getDouble('reader_margin');
  }

  Future<void> setReaderMargin(double v) async {
    final p = await _prefs;
    await p.setDouble('reader_margin', v);
  }

  Future<List<String>> getProxyList() async {
    final p = await _prefs;
    return p.getStringList('proxy_list') ?? [];
  }

  Future<void> setProxyList(List<String> list) async {
    final p = await _prefs;
    await p.setStringList('proxy_list', list);
  }

  Future<List<String>> getBookFormats() async {
    final p = await _prefs;
    return p.getStringList('book_formats');
  }

  Future<void> setBookFormats(List<String> list) async {
    final p = await _prefs;
    await p.setStringList('book_formats', list);
  }

  Future<List<String>> getBookLanguages() async {
    final p = await _prefs;
    return p.getStringList('book_languages');
  }

  Future<void> setBookLanguages(List<String> list) async {
    final p = await _prefs;
    await p.setStringList('book_languages', list);
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final p = await _prefs;
    return p.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    final p = await _prefs;
    await p.setBool(key, value);
  }

  Future<String> getString(String key) async {
    final p = await _prefs;
    return p.getString(key);
  }

  Future<void> setString(String key, String value) async {
    final p = await _prefs;
    await p.setString(key, value);
  }
}
