import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/mensa_info.dart';
import 'package:ikus_app/model/ovgu_account.dart';
import 'package:ikus_app/model/settings_data.dart';

/// manages hive (persistent) storage and secure storage
/// no class except this class has dependency to hive or secure storage
class PersistentService {

  static final PersistentService _instance = PersistentService();
  static PersistentService get instance => _instance;

  static const String _BOX_DEVICE_ID = 'device_id';
  static const String _BOX_SETTINGS = 'settings';
  static const String _BOX_LAST_SYNC = 'last_sync';
  static const String _BOX_API_JSON = 'api_json';
  static const String _BOX_API_BINARY = 'api_binary';

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// initializes hive storage
  /// must be called before first hive access
  Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(_BOX_DEVICE_ID);
    await Hive.openBox(_BOX_SETTINGS);
    await Hive.openBox<DateTime>(_BOX_LAST_SYNC);
    await Hive.openBox<String>(_BOX_API_JSON);
    await Hive.openBox<Uint8List>(_BOX_API_BINARY);
  }

  /// wipes all data except device id
  Future<void> clearData() async {
    await Hive.box(_BOX_SETTINGS).clear();
    await Hive.box<DateTime>(_BOX_LAST_SYNC).clear();
    await Hive.box<String>(_BOX_API_JSON).clear();
    await Hive.box<Uint8List>(_BOX_API_BINARY).clear();
    await _secureStorage.deleteAll();
  }

  // device id

  String getDeviceId() {
    return Hive.box(_BOX_DEVICE_ID).get('device_id');
  }

  void setDeviceId(String deviceId) {
    Hive.box(_BOX_DEVICE_ID).put('device_id', deviceId);
  }

  // api storage

  ApiData<Uint8List> getApiBinary(String key) {
    final Uint8List binary = Hive.box<Uint8List>(_BOX_API_BINARY).get(key);
    final DateTime timestamp = Hive.box<DateTime>(_BOX_LAST_SYNC).get(key);
    return binary != null && timestamp != null ? ApiData(data: binary, timestamp: timestamp) : null;
  }

  void setApiBinary(String key, ApiData<Uint8List> data) {
    Hive.box<Uint8List>(_BOX_API_BINARY).put(key, data.data);
    Hive.box<DateTime>(_BOX_LAST_SYNC).put(key, data.timestamp);
  }

  ApiData<String> getApiJson(String key) {
    final String json = Hive.box<String>(_BOX_API_JSON).get(key);
    final DateTime timestamp = Hive.box<DateTime>(_BOX_LAST_SYNC).get(key);
    return json != null && timestamp != null ? ApiData(data: json, timestamp: timestamp) : null;
  }

  void setApiJson(String key, ApiData<String> data) {
    Hive.box<String>(_BOX_API_JSON).put(key, data.data);
    Hive.box<DateTime>(_BOX_LAST_SYNC).put(key, data.timestamp);
  }

  DateTime getApiTimestamp(String key) {
    return Hive.box<DateTime>(_BOX_LAST_SYNC).get(key);
  }

  // settings

  SettingsData getSettings() {
    final Box box = Hive.box(_BOX_SETTINGS);
    return SettingsData(
      welcome: box.get('welcome', defaultValue: true),
      locale: box.get('locale'),
      favorites: box
          .get('favorite_feature_list', defaultValue: [])
          ?.cast<int>(),
      newsChannels: box
          .get('news_channels')
          ?.cast<int>(),
      calendarChannels: box
          .get('calendar_channels')
          ?.cast<int>(),
      myEvents: box
          .get('my_events', defaultValue: [])
          .cast<int>(),
      mensa: (box.get('mensa') as String)?.toMensa() ?? Mensa.UNI_CAMPUS_DOWN,
      devSettings: box.get('dev_settings', defaultValue: false),
      devServer: box.get('dev_server', defaultValue: false)
    );
  }

  void setSettings(SettingsData data) {
    final Box box = Hive.box(_BOX_SETTINGS);
    box.put('welcome', data.welcome);
    box.put('locale', data.locale);
    box.put('favorite_feature_list', data.favorites);
    box.put('news_channels', data.newsChannels);
    box.put('calendar_channels', data.calendarChannels);
    box.put('my_events', data.myEvents);
    box.put('mensa', describeEnum(data.mensa));
    box.put('dev_settings', data.devSettings);
    box.put('dev_server', data.devServer);
  }

  // ovgu account

  Future<OvguAccount> getOvguAccount() async {
    String ovguName = await _secureStorage.read(key: 'ovgu_name');
    String ovguPassword = await _secureStorage.read(key: 'ovgu_password');
    return ovguName != null && ovguPassword != null ? OvguAccount(name: ovguName, password: ovguPassword) : null;
  }

  Future<void> setOvguAccount(OvguAccount account) async {
    await _secureStorage.write(key: 'ovgu_name', value: account.name);
    await _secureStorage.write(key: 'ovgu_password', value: account.password);
  }

  Future<void> deleteOvguAccount() async {
    await _secureStorage.delete(key: 'ovgu_name');
    await _secureStorage.delete(key: 'ovgu_password');
  }
}