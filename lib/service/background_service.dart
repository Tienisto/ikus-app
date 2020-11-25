import 'package:background_fetch/background_fetch.dart';
import 'package:ikus_app/service/notification_service.dart';

/// executes code in background
class BackgroundService {

  static final BackgroundService _instance = BackgroundService();
  static BackgroundService get instance => _instance;

  void init() {
    final config = BackgroundFetchConfig(minimumFetchInterval: 15);
    BackgroundFetch.configure(config, backgroundTaskDispatcher);
  }
}

void backgroundTaskDispatcher(String taskId) {
  print('Running background task... ($taskId)');
  NotificationService notificationService = NotificationService.createInstance();
  notificationService.showTest();
  BackgroundFetch.finish(taskId);
}