import 'dart:io';

import 'package:ikus_app/init.dart';
import 'package:ikus_app/model/local/background_task.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
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

Future<void> backgroundTask(String taskId, LogServiceSync logServiceSync) async {
  print('Running background task... ($taskId)');

  await Init.init();
  await Init.postInit(appStart: false, logServiceSync: logServiceSync); // also syncing data and showing notifications
}

void workmanagerWrapper() {
  Workmanager.executeTask((String task, Map<String, dynamic> inputData) async {
    DateTime start = DateTime.now();
    bool success = false;
    List<String> tasks;
    try {
      await backgroundTask(task, (List<String> t) => tasks = t);
      success = true;
      return true;
    } catch (e) {
      return false;
    } finally {
      final loggingTask = BackgroundTask()
        ..start = start
        ..end = DateTime.now()
        ..success = success
        ..services = tasks ?? [];
      await PersistentService.instance.addBackgroundTask(loggingTask);
      await PersistentService.instance.close(); // ensure that everything is committed
    }
  });
}