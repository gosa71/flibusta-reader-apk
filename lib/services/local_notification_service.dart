class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {}

  Future<void> showNotification({String title, String body}) async {}
}
