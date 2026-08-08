import 'package:utopic_toast/utopic_toast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsUtils {
  static Future<bool> requestStoragePermission(BuildContext context) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      Toast.show(
        'Разрешение на доступ к хранилищу отклонено навсегда. Откройте настройки приложения.',
        duration: Toast.LENGTH_LONG,
      );
      await openAppSettings();
      return false;
    }

    status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    }

    Toast.show(
      'Для работы приложения необходимо разрешение на доступ к хранилищу',
      duration: Toast.LENGTH_LONG,
    );
    return false;
  }

  static Future<bool> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    }
    status = await Permission.notification.request();
    return status.isGranted;
  }
}
