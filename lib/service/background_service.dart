
import 'package:ikus_app/service/notification_service.dart';
import 'package:workmanager/workmanager.dart';

/// executes code in background
class BackgroundService {

  static final BackgroundService _instance = BackgroundService();
  static BackgroundService get instance => _instance;

  void init() {
    Workmanager.initialize(backgroundTaskDispatcher);
    Workmanager.registerPeriodicTask(
      "1",
      "fetchMailsTask",
      frequency: Duration(minutes: 15), // at least 15min
      existingWorkPolicy: ExistingWorkPolicy.replace
    );
  }
}

void backgroundTaskDispatcher() {
  Workmanager.executeTask((task, inputData) {

    NotificationService notificationService = NotificationService.createInstance();
    //notificationService.showTest();

    return Future.value(true);
  });
}