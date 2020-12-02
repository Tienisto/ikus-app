import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikus_app/model/data_with_timestamp.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/model/mensa_info.dart';
import 'package:ikus_app/model/ovgu_account.dart';
import 'package:ikus_app/model/settings_data.dart';

/// manages hive (persistent) storage and secure storage
/// no class except this class has dependency to hive or secure storage
class PersistentService {

  static final PersistentService _instance = PersistentService();
  static PersistentService get instance => _instance;

  static const String _BOX_DEVICE_ID = 'device_id'; // contains device id only
  static const String _BOX_SETTINGS = 'settings'; // settings, ovgu account
  static const String _BOX_LAST_SYNC = 'last_sync'; // timestamps for api_json and api_binary
  static const String _BOX_API_JSON = 'api_json'; // json responses from API
  static const String _BOX_API_BINARY = 'api_binary'; // binary responses from API
  static const String _BOX_MAILS = 'mails'; // contains all mails (without attachments) as JSON
  static const String _BOX_MAILS_META = 'mails_meta'; // metadata for mails

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
    await Hive.openBox<String>(_BOX_MAILS);
    await Hive.openBox(_BOX_MAILS_META);
  }

  /// wipes all data except device id
  Future<void> clearData() async {
    await Hive.box(_BOX_SETTINGS).clear();
    await Hive.box<DateTime>(_BOX_LAST_SYNC).clear();
    await Hive.box<String>(_BOX_API_JSON).clear();
    await Hive.box<Uint8List>(_BOX_API_BINARY).clear();
    await Hive.box<String>(_BOX_MAILS).clear();
    await Hive.box(_BOX_MAILS_META).clear();
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

  DataWithTimestamp<Uint8List> getApiBinary(String key) {
    final Uint8List binary = Hive.box<Uint8List>(_BOX_API_BINARY).get(key);
    final DateTime timestamp = Hive.box<DateTime>(_BOX_LAST_SYNC).get(key);
    return binary != null && timestamp != null ? DataWithTimestamp(data: binary, timestamp: timestamp) : null;
  }

  void setApiBinary(String key, DataWithTimestamp<Uint8List> data) {
    Hive.box<Uint8List>(_BOX_API_BINARY).put(key, data.data);
    Hive.box<DateTime>(_BOX_LAST_SYNC).put(key, data.timestamp);
  }

  DataWithTimestamp<String> getApiJson(String key) {
    final String json = Hive.box<String>(_BOX_API_JSON).get(key);
    final DateTime timestamp = Hive.box<DateTime>(_BOX_LAST_SYNC).get(key);
    return json != null && timestamp != null ? DataWithTimestamp(data: json, timestamp: timestamp) : null;
  }

  void setApiJson(String key, DataWithTimestamp<String> data) {
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
    String mailAddress = await _secureStorage.read(key: 'ovgu_mail_address');
    if (ovguName == null || ovguPassword == null) {
      return null;
    } else {
      return OvguAccount(
          name: ovguName,
          password: ovguPassword,
          mailAddress: mailAddress
      );
    }
  }

  Future<void> setOvguAccount(OvguAccount account) async {
    await _secureStorage.write(key: 'ovgu_name', value: account.name);
    await _secureStorage.write(key: 'ovgu_password', value: account.password);
    await _secureStorage.write(key: 'ovgu_mail_address', value: account.mailAddress);
  }

  Future<void> deleteOvguAccount() async {
    await _secureStorage.delete(key: 'ovgu_name');
    await _secureStorage.delete(key: 'ovgu_password');
    await _secureStorage.delete(key: 'ovgu_mail_address');
  }

  // mails

  DataWithTimestamp<Map<int, MailMessage>> getMails() {
    final timestamp = Hive.box(_BOX_MAILS_META).get('last_update');
    if (timestamp != null) {
      final mails = Hive.box<String>(_BOX_MAILS).toMap()
          .map((key, value) => MapEntry(key, MailMessage.fromMap(json.decode(value))));
      return DataWithTimestamp(data: Map.from(mails), timestamp: timestamp);
    } else {
      return null;
    }
  }

  Future<void> setMails(DataWithTimestamp<Map<int, MailMessage>> data) async {
    final serialized = data.data.map((key, value) => MapEntry(key, json.encode(value.toMap())));
    final box = Hive.box<String>(_BOX_MAILS);
    await box.clear();
    await box.putAll(serialized);
    await Hive.box(_BOX_MAILS_META).put('last_update', data.timestamp);
  }
}