

import 'package:flutter/cupertino.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

Future<void> postInit(BuildContext context) async {
  await appStart(context);
  await updateOldData();
  print('post init finished');
}

/// sends app start signal to server
Future<void> appStart(BuildContext context) async {
  await ApiService.appStart(context);
}

/// update old data based on maxAge
Future<void> updateOldData() async {

  // not on the first start
  if (SettingsService.instance.getWelcome())
    return;

  DateTime now = DateTime.now();
  for (SyncableService service in SyncableService.services) {
    Duration age = now.difference(service.getLastUpdate());
    if (age >= service.getMaxAge()) {
      await service.sync(useCacheOnly: false);
      print('[sync] ${service.getName()}: ${service.getLastUpdate()} ($age >= ${service.getMaxAge()})');
    } else {
      print('[sync] ${service.getName()}: ${service.getLastUpdate()} ($age < ${service.getMaxAge()}) -> up-to-date');
    }
  }
  DateTime after = DateTime.now();
  print('[sync] took ${after.difference(now)}');
}