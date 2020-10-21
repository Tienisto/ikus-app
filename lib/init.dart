import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Init {
  static final DateFormat _lastModifiedFormatter = DateFormat("dd.MM.yyyy HH:mm:ss");
  static bool _postInitFinished = false;
  static bool get postInitFinished => _postInitFinished;

  /// runs before the first frame
  static Future<void> init() async {
    await _initHive();
    await _initDeviceId();
    await _initLocalSettings();
    await _initLocalApiCache();
    print('init finished');
  }

  /// runs after the first frame
  static Future<void> postInit(BuildContext context) async {

    await _syncAppConfig(context);

    if (!AppConfigService.instance.isCompatibleWithApi()) {
      _postInitFinished = true;
      print('post init finished (ignore further api calls)');
      return;
    }

    await _appStart(context);
    await _updateOldData();
    _postInitFinished = true;
    print('post init finished');
  }

  /// initializes hive boxes
  static Future<void> _initHive() async {
    print('[1 / 4] init local storage (hive)');
    await Hive.openBox('device_id');
    await Hive.openBox('settings');
    await Hive.openBox<DateTime>('last_sync');
    await Hive.openBox<String>('api_json');
    await Hive.openBox<Uint8List>('api_binary');
  }

  /// initialize the device id if needed
  static Future<void> _initDeviceId() async {
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
  static Future<void> _initLocalSettings() async {

    print('[3 / 4] init settings');

    // init settings
    await SettingsService.instance.init();

    // set locale
    String locale = SettingsService.instance.getLocale();
    if (locale != null) {
      print(' -> use locale: $locale');
      LocaleSettings.setLocale(locale);
    }
  }

  /// initializes every syncable service with the data from local storage
  static Future<void> _initLocalApiCache() async {
    print('[4 / 4] init api cache');
    List<SyncableService> services = SyncableService.services;
    for(SyncableService service in services) {
      await service.sync(useCacheOnly: true);
    }
  }

  static Future<void> _syncAppConfig(BuildContext context) async {
    print('[1 / 3] sync app config');
    await AppConfigService.instance.sync(useCacheOnly: false);
  }

  /// sends app start signal to server
  static Future<void> _appStart(BuildContext context) async {
    print('[2 / 3] app start');
    await ApiService.appStart(context);
  }

  /// update old data based on maxAge
  static Future<void> _updateOldData() async {

    print('[3 / 3] check if old data needs to be refetched');

    // not on the first start
    if (SettingsService.instance.getWelcome())
      return;

    DateTime now = DateTime.now();
    for (SyncableService service in SyncableService.servicesWithoutAppConfig) {
      Duration age = now.difference(service.getLastUpdate());
      String lastUpdateString = _lastModifiedFormatter.format(service.getLastUpdate());
      if (age >= service.getMaxAge()) {
        print(' -> ${service.getName().padRight(18)}: $lastUpdateString ($age >= ${service.getMaxAge()}) -> fetch');
        await service.sync(useCacheOnly: false);
      } else {
        print(' -> ${service.getName().padRight(18)}: $lastUpdateString ($age < ${service.getMaxAge()}) -> up-to-date');
      }
    }
    DateTime after = DateTime.now();
    print(' -> step took ${after.difference(now)}');
  }
}