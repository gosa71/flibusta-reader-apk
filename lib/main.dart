import 'dart:io';

import 'package:flibusta/ds_controls/dynamic_theme_mode.dart';
import 'package:flibusta/ds_controls/internet_checker.dart';
import 'package:flibusta/ds_controls/theme.dart';
import 'package:flibusta/services/http_client/http_client.dart';
import 'package:flibusta/services/local_notification_service.dart';
import 'package:flibusta/services/local_storage.dart';
import 'package:flibusta/utils/permissions_utils.dart';
import 'package:flutter/material.dart';
import 'package:flibusta/route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'utils/file_utils.dart';

void main() async {
  await initialization();
  runApp(FlibustaApp());
}

Future<void> initialization() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  try {
    await PermissionsUtils.requestAccess(null, Permission.storage);
  } catch (_) {}

  try {
    await NotificationService().init();
  } catch (_) {}

  try {
    final proxy = await LocalStorage().getActualProxy();
    ProxyHttpClient().setProxy(proxy ?? '');
  } catch (_) {}

  try {
    final url = await LocalStorage().getHostAddress();
    ProxyHttpClient().setHostAddress(url);
  } catch (_) {}

  try {
    final dir = await FileUtils.getStorageDir();
    await LocalStorage().setBooksDirectory(dir);
  } catch (_) {}
}

class FlibustaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicThemeMode(
      child: Builder(
        builder: (context) {
          final themeState = DynamicThemeMode.of(context);
          final mode = themeState?.themeMode ?? ThemeMode.system;
          return MaterialApp(
            title: 'Флибуста - книжное братство',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: mode,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('ru', 'RU'),
              const Locale('en', 'US'),
            ],
            locale: const Locale('ru', 'RU'),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: '/',
            builder: (context, child) {
              return InternetChecker(child: child);
            },
          );
        },
      ),
    );
  }
}
