import 'dart:io';

import 'package:ikus_app/service/notification_service.dart';
import 'package:workmanager/workmanager.dart';

/// executes code in background
class BackgroundService {

  static final BackgroundService _instance = BackgroundService();
  static BackgroundService get instance => _instance;

  void init() {
    Workmanager.initialize(workmanagerWrapper);
    if (Platform.isAndroid) {
      Workmanager.registerPeriodicTask(
          "1",
          "fetchTask",
          frequency: Duration(minutes: 15), // at least 15min
          existingWorkPolicy: ExistingWorkPolicy.replace
      );
    }
  }
}

void backgroundTaskDispatcher(String taskId) {
  print('Running background task... ($taskId)');
  NotificationService notificationService = NotificationService.createInstance();
  notificationService.showTest();
}

void workmanagerWrapper() {
  Workmanager.executeTask((String task, Map<String, dynamic> inputData) {
    backgroundTaskDispatcher(task);
    return Future.value(true);
  });
}