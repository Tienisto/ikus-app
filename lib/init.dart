import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

Future<void> init() async {
  await _initHive();
  await _initSettings();
  await _initApiCache();
  print('initialized');
}

/// initializes hive boxes
Future<void> _initHive() async {
  await Hive.openBox('settings');
  await Hive.openBox<DateTime>('last_sync');
  await Hive.openBox<String>('api_json');
  await Hive.openBox<Uint8List>('api_binary');
}

/// initializes the settings
Future<void> _initSettings() async {

  // init settings
  SettingsService.instance.init();

  // set locale
  String locale = SettingsService.instance.getLocale();
  if (locale != null) {
    print('[storage] use locale: $locale');
    LocaleSettings.setLocale(locale);
  }
}

/// initializes every syncable service with the data from local storage
Future<void> _initApiCache() async {
  List<SyncableService> services = SyncableService.services;
  for(SyncableService service in services) {
    await service.sync(useCacheOnly: true);
  }
}