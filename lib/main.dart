import 'dart:io';

import 'package:flibusta/ds_controls/dynamic_theme_mode.dart';
import 'package:flibusta/ds_controls/internet_checker.dart';
import 'package:flibusta/ds_controls/theme.dart';
import 'package:flibusta/services/http_client/http_client.dart';
import 'package:flibusta/services/local_notification_service.dart';
import 'package:flibusta/services/local_storage.dart';
import 'package:flibusta/utils/permissions_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flibusta/route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:utopic_toast/utopic_toast.dart';

import 'utils/file_utils.dart';

main() async {
  await initialization();
  runApp(FlibustaApp());
}

Future<void> initialization() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  await LocalStorage().init();
  await ProxyHttpClient().init();
  await LocalNotificationService().init();
  await PermissionsUtils.requestPermissions();
}

class FlibustaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicThemeMode(
      themedWidgetBuilder: (context, themeMode) {
        return MaterialApp(
          title: 'Флибуста',
          theme: kLightTheme,
          darkTheme: kDarkTheme,
          themeMode: themeMode,
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
          onGenerateRoute: Router.generateRoute,
          initialRoute: '/',
          builder: (context, child) {
            return InternetChecker(
              child: ToastOverlay(child: child),
            );
          },
        );
      },
    );
  }
}
