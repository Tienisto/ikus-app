import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final DateFormat _lastModifiedFormatter = DateFormat("dd.MM.yyyy HH:mm:ss");

/// runs before the first frame
Future<void> init() async {
  await _initHive();
  await _initDeviceId();
  await _initSettings();
  await _initApiCache();
  print('init finished');
}

/// runs after the first frame
Future<void> postInit(BuildContext context) async {
  await _appStart(context);
  await _updateOldData();
  print('post init finished');
}

/// initializes hive boxes
Future<void> _initHive() async {
  print('[1 / 4] init local storage (hive)');
  await Hive.openBox('device_id');
  await Hive.openBox('settings');
  await Hive.openBox<DateTime>('last_sync');
  await Hive.openBox<String>('api_json');
  await Hive.openBox<Uint8List>('api_binary');
}

/// initialize the device id if needed
Future<void> _initDeviceId() async {
  print('[2 / 4] init device id');
  Box box = Hive.box('device_id');
  String deviceId = box.get('device_id');
  if (deviceId == null) {
    // initialize
    deviceId = Uuid().v4();
    print(' -> set device id: $deviceId');
    box.put('device_id', deviceId);
  }
}

/// initializes the settings
Future<void> _initSettings() async {

  print('[3 / 4] init settings');

  // init settings
  SettingsService.instance.init();

  // set locale
  String locale = SettingsService.instance.getLocale();
  if (locale != null) {
    print(' -> use locale: $locale');
    LocaleSettings.setLocale(locale);
  }
}

/// initializes every syncable service with the data from local storage
Future<void> _initApiCache() async {
  print('[4 / 4] init api cache');
  List<SyncableService> services = SyncableService.services;
  for(SyncableService service in services) {
    await service.sync(useCacheOnly: true);
  }
}

/// sends app start signal to server
Future<void> _appStart(BuildContext context) async {
  print('[1 / 2] app start');
  await ApiService.appStart(context);
}

/// update old data based on maxAge
Future<void> _updateOldData() async {

  print('[2 / 2] check if old data needs to be refetched');

  // not on the first start
  if (SettingsService.instance.getWelcome())
    return;

  DateTime now = DateTime.now();
  for (SyncableService service in SyncableService.services) {
    Duration age = now.difference(service.getLastUpdate());
    String lastUpdateString = _lastModifiedFormatter.format(service.getLastUpdate());
    if (age >= service.getMaxAge()) {
      print(' -> ${service.getName().padRight(12)}: $lastUpdateString ($age >= ${service.getMaxAge()}) -> fetch');
      await service.sync(useCacheOnly: false);
    } else {
      print(' -> ${service.getName().padRight(12)}: $lastUpdateString ($age < ${service.getMaxAge()}) -> up-to-date');
    }
  }
  DateTime after = DateTime.now();
  print(' -> step took ${after.difference(now)}');
}