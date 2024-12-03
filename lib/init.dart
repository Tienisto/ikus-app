import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/service/background_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/notification_payload_serialization.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Init {

  static const String LOG_NAME = 'Init';
  static final DateFormat _lastModifiedFormatter = DateFormat("dd.MM.yyyy HH:mm:ss");
  static bool _postInitFinished = false;
  static bool get postInitFinished => _postInitFinished;

  /// runs before app has even run
  /// returns a screen when handling notification start
  static Future<SimpleWidgetBuilder?> preInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    LocaleSettings.useDeviceLocale();
    BackgroundService.instance.init();
    NotificationAppLaunchDetails? details = await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp && details.notificationResponse?.payload != null) {
      return NotificationPayloadSerialization.parse(details.notificationResponse!.payload!);
    } else {
      return null;
    }
  }

  /// similar to [preInit] but for background tasks
  static Future<void> preInitBackground() async {
    WidgetsFlutterBinding.ensureInitialized();
    //LocaleSettings.useDeviceLocale(); (not working yet, use locale from storage)
    await initializeDateFormatting();
  }

  /// runs before the first frame and after state initialization
  /// - initialization of services using storage data
  /// - no network traffic happen here
  static Future<void> init() async {
    await _initHive();
    await _initDeviceId();
    await _initLocalSettings();
    await _initLocalApiCache();
    log('Done.', name: LOG_NAME);
  }

  /// runs after the first frame
  /// - network stuff like syncing data with API
  static Future<void> postInit({bool appStart = true, BackgroundSyncCallback? backgroundSyncCallback}) async {

    await _syncAppConfig();

    if (!AppConfigService.instance.isCompatibleWithApi()) {
      _postInitFinished = true;
      log('post init finished (skip "app start" and "update old data")', name: LOG_NAME);
      return;
    }

    if (ApiService.usedNetworkOnLastJSONFetch == false) {
      _postInitFinished = true;
      log('post init finished (no network)', name: LOG_NAME);
      if (backgroundSyncCallback != null) {
        backgroundSyncCallback([], 'No network');
      }
      return;
    }

    if (appStart) {
      await _appStart();
    }

    await _updateOldData(backgroundSyncCallback);
    _postInitFinished = true;
    log('post init finished', name: LOG_NAME);
  }

  /// waits until postInit finished
  static Future<void> awaitPostInit() async {
    do {
      await sleep(1000);
    } while (!Init.postInitFinished);
  }

  /// initializes hive boxes
  static Future<void> _initHive() async {
    log('[1 / 4] init local storage (hive)', name: LOG_NAME);
    await PersistentService.instance.initHive();
  }

  /// initialize the device id if needed
  static Future<void> _initDeviceId() async {
    log('[2 / 4] init device id', name: LOG_NAME);
    String? deviceId = PersistentService.instance.getDeviceId();
    if (deviceId == null) {
      // initialize
      deviceId = Uuid().v4();
      log(' -> set device id: $deviceId', name: LOG_NAME);
      await PersistentService.instance.setDeviceId(deviceId);
    }
  }

  /// initializes the settings
  static Future<void> _initLocalSettings() async {
    log('[3 / 4] init settings', name: LOG_NAME);

    // init settings
    await SettingsService.instance.loadFromStorage();

    // set locale
    String? locale = SettingsService.instance.getLocale();
    if (locale != null) {
      log(' -> use locale: $locale', name: LOG_NAME);
      LocaleSettings.setLocaleRaw(locale);
    } else {
      String deviceLocale = LocaleSettings.currentLocale.languageTag;
      log(' -> use default device locale: $deviceLocale', name: LOG_NAME);
      SettingsService.instance.setLocale(deviceLocale);
    }
  }

  /// initializes every syncable service with the data from local storage
  static Future<void> _initLocalApiCache() async {
    log('[4 / 4] init api cache', name: LOG_NAME);
    List<SyncableService> services = SyncableService.services;
    for(SyncableService service in services) {
      await service.sync(useNetwork: false);
    }
  }

  static Future<void> _syncAppConfig() async {
    log('[1 / 3] sync app config', name: LOG_NAME);
    await AppConfigService.instance.sync(useNetwork: true);
  }

  /// sends app start signal to server
  static Future<void> _appStart() async {
    log('[2 / 3] app start', name: LOG_NAME);
    await ApiService.appStart();
  }

  /// update old data based on maxAge
  static Future<void> _updateOldData(BackgroundSyncCallback? backgroundSyncCallback) async {
    log('[3 / 3] check if old data needs to be refetched', name: LOG_NAME);

    // not on the first start
    if (SettingsService.instance.getWelcome()) {
      return;
    }

    final now = DateTime.now();
    final fetchList = <SyncableService>[];
    final batchResult = <SyncableService, String>{};

    // prepare outdated services
    log(' -> (1/4) check outdated', name: LOG_NAME);
    for (final service in SyncableService.servicesWithoutAppConfig) {
      final age = now.difference(service.getLastUpdate());
      final lastUpdateString = _lastModifiedFormatter.format(service.getLastUpdate());
      if (age >= service.maxAge) {
        log(' -> ${service.id.padRight(18)}: $lastUpdateString ($age >= ${service.maxAge}) -> fetch', name: LOG_NAME);
        fetchList.add(service);
      } else {
        log(' -> ${service.id.padRight(18)}: $lastUpdateString ($age < ${service.maxAge}) -> up-to-date', name: LOG_NAME);
      }
    }

    if (backgroundSyncCallback != null) {
      backgroundSyncCallback(fetchList.map((s) => s.id).toList());
    }

    // batch fetch
    final List<String> routes = fetchList
        .where((service) => service.batchKey != null)
        .map((service) => service.batchKey)
        .nonNulls
        .toList();
    if (routes.isNotEmpty) {
      log(' -> (2/4) fetch batch route', name: LOG_NAME);
      String? response = await ApiService.fetchBatchString(locale: LocaleSettings.currentLocale.languageTag, routes: routes);
      if (response != null) {
        Map<String, dynamic> parsed = json.decode(response);
        for (final entry in parsed.entries) {
          SyncableService? service = SyncableService.servicesWithoutAppConfig.firstWhereOrNull((s) => s.batchKey == entry.key);
          if (service != null) {
            batchResult[service] = entry.value; // add batch result
          }
        }
      }
    } else {
      log(' -> (2/4) no compatible batch service found', name: LOG_NAME);
    }

    // apply fetch list with batch data
    log(' -> (3/4) sync', name: LOG_NAME);
    final postSyncTasks = <FutureCallback>[];
    for (SyncableService service in fetchList) {
      final String? useJSON = batchResult[service];
      log(' -> ${service.id.padRight(18)}: ${useJSON != null ? 'has batch result' : 'no batch (fetch individually)'}', name: LOG_NAME);
      await service.sync(
        useNetwork: true, // useNetwork must be true, e.g. handbook
        useJSON: useJSON,
        showNotifications: true,
        onBatchFinished: (callback) => postSyncTasks.add(callback)
      );
    }

    // post sync (e.g. show notifications)
    log(' -> (4/4) post sync (e.g. notifications)', name: LOG_NAME);
    for (FutureCallback postSyncTask in postSyncTasks) {
      await postSyncTask();
    }

    log(' -> update old data step took ${DateTime.now().difference(now)}', name: LOG_NAME);
  }
}
