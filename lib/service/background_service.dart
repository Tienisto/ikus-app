import 'dart:io';

import 'package:ikus_app/init.dart';
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
          initialDelay: Duration(minutes: 15),
          existingWorkPolicy: ExistingWorkPolicy.replace
      );
    }
  }
}

Future<void> backgroundTask(String taskId) async {
  print('Running background task... ($taskId)');

  await Init.init();
  await Init.postInit(appStart: false); // also syncing data and showing notifications
}

void workmanagerWrapper() {
  Workmanager.executeTask((String task, Map<String, dynamic> inputData) async {
    try {
      await backgroundTask(task);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  });
}