class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // alias used by older main
  static NotificationService get instance => _instance;

  Future<void> init() async {}

  Future<void> showNotification({String title, String body}) async {}
}

// alias
class LocalNotificationService {
  Future<void> init() async => NotificationService().init();
}
