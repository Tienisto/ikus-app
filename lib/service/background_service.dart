import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:ikus_app/service/notification_service.dart';
import 'package:workmanager/workmanager.dart';

/// executes code in background
class BackgroundService {

  static final BackgroundService _instance = BackgroundService();
  static BackgroundService get instance => _instance;

  void init() {
    if (Platform.isAndroid) {
      Workmanager.initialize(workmanagerWrapper);
      Workmanager.registerPeriodicTask(
          "1",
          "fetchTask",
          frequency: Duration(minutes: 15), // at least 15min
          existingWorkPolicy: ExistingWorkPolicy.replace
      );
    } else {
      final config = BackgroundFetchConfig(minimumFetchInterval: 15, startOnBoot: true, enableHeadless: true, stopOnTerminate: false);
      BackgroundFetch.configure(config, backgroundTaskDispatcher);
    }
  }
}

void backgroundTaskDispatcher(String taskId) {
  print('Running background task... ($taskId)');
  NotificationService notificationService = NotificationService.createInstance();
  notificationService.showTest();

  if (!Platform.isAndroid)
    BackgroundFetch.finish(taskId);
}

void workmanagerWrapper() {
  Workmanager.executeTask((String task, Map<String, dynamic> inputData) {
    backgroundTaskDispatcher(task);
    return Future.value(true);
  });
}