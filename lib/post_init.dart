

import 'package:ikus_app/service/syncable_service.dart';

Future<void> postInit() async {
  await syncOldData();
  print('post init finished');
}

/// sync data based on maxAge
Future<void> syncOldData() async {
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