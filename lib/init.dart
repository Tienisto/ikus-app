import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/service/background_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/notification_payload_serialization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Init {
  static final DateFormat _lastModifiedFormatter = DateFormat("dd.MM.yyyy HH:mm:ss");
  static bool _postInitFinished = false;
  static bool get postInitFinished => _postInitFinished;

  /// runs before app has even run
  /// returns a screen when handling notification start
  static Future<SimpleWidgetBuilder> preInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    LocaleSettings.useDeviceLocale();
    BackgroundService.instance.init();
    await initializeDateFormatting();
    NotificationAppLaunchDetails details = await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
    if (details.didNotificationLaunchApp && details.payload != null) {
      return NotificationPayloadSerialization.parse(details.payload);
    } else {
      return null;
    }
  }

  /// runs before the first frame and after state initialization
  static Future<void> init() async {
    await _initHive();
    await _initDeviceId();
    await _initLocalSettings();
    await _initLocalApiCache();
  }

  /// runs after the first frame
  static Future<void> postInit({bool appStart = true}) async {

    await _syncAppConfig();

    if (!AppConfigService.instance.isCompatibleWithApi()) {
      _postInitFinished = true;
      print('post init finished (skip app start and update old data)');
      return;
    }

    if (appStart) {
      await _appStart();
    }

    await _updateOldData();
    _postInitFinished = true;
    print('post init finished');
  }

  /// waits until postInit finished
  static Future<void> awaitPostInit() async {
    do {
      await sleep(1000);
    } while (!Init.postInitFinished);
  }

  /// initializes hive boxes
  static Future<void> _initHive() async {
    print('[1 / 4] init local storage (hive)');
    await PersistentService.instance.initHive();
  }

  /// initialize the device id if needed
  static Future<void> _initDeviceId() async {
    print('[2 / 4] init device id');
    String deviceId = PersistentService.instance.getDeviceId();
    if (deviceId == null) {
      // initialize
      deviceId = Uuid().v4();
      print(' -> set device id: $deviceId');
      PersistentService.instance.setDeviceId(deviceId);
    }
  }

  /// initializes the settings
  static Future<void> _initLocalSettings() async {

    print('[3 / 4] init settings');

    // init settings
    await SettingsService.instance.loadFromStorage();

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
      await service.sync(useNetwork: false);
    }
  }

  static Future<void> _syncAppConfig() async {
    print('[1 / 3] sync app config');
    await AppConfigService.instance.sync(useNetwork: true);
  }

  /// sends app start signal to server
  static Future<void> _appStart() async {
    print('[2 / 3] app start');
    await ApiService.appStart();
  }

  /// update old data based on maxAge
  static Future<void> _updateOldData() async {

    print('[3 / 3] check if old data needs to be refetched');

    // not on the first start
    if (SettingsService.instance.getWelcome())
      return;

    DateTime now = DateTime.now();
    List<SyncableService> fetchList = List();
    Map<SyncableService, String> batchResult = Map();

    // prepare outdated services
    print(' -> (1/3) check outdated');
    for (SyncableService service in SyncableService.servicesWithoutAppConfig) {
      Duration age = now.difference(service.getLastUpdate());
      String lastUpdateString = _lastModifiedFormatter.format(service.getLastUpdate());
      if (age >= service.maxAge) {
        print(' -> ${service.getName().padRight(18)}: $lastUpdateString ($age >= ${service.maxAge}) -> fetch');
        fetchList.add(service);
      } else {
        print(' -> ${service.getName().padRight(18)}: $lastUpdateString ($age < ${service.maxAge}) -> up-to-date');
      }
    }

    // batch fetch
    List<String> routes = fetchList
        .where((service) => service.batchKey != null)
        .map((service) => service.batchKey)
        .toList();
    if (routes.isNotEmpty) {
      print(' -> (2/3) fetch batch route');
      String response = await ApiService.fetchBatchString(locale: LocaleSettings.currentLocale, routes: routes);
      if (response != null) {
        Map<String, dynamic> parsed = json.decode(response);
        for (final entry in parsed.entries) {
          SyncableService service = SyncableService.servicesWithoutAppConfig.firstWhere((s) => s.batchKey == entry.key, orElse: () => null);
          if (service != null) {
            batchResult[service] = entry.value; // add batch result
          }
        }
      }
    } else {
      print(' -> (2/3) no compatible batch service found');
    }

    // apply fetch list with batch data
    print(' -> (3/3) sync');
    for (SyncableService service in fetchList) {
      String useJSON = batchResult[service];
      print(' -> ${service.getName().padRight(18)}: ${useJSON != null ? 'has batch result' : 'no batch (fetch individually)'}');
      await service.sync(
          useNetwork: true, // useNetwork must be true, e.g. handbook
          useJSON: useJSON,
          showNotifications: true
      );
    }

    DateTime after = DateTime.now();
    print(' -> update old data step took ${after.difference(now)}');
  }
}