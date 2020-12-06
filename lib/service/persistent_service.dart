import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikus_app/model/data_with_timestamp.dart';
import 'package:ikus_app/model/local/background_task.dart';
import 'package:ikus_app/model/local/log_error.dart';
import 'package:ikus_app/model/mail_collection.dart';
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
  static const String _BOX_MAILS_INBOX = 'mails_inbox'; // contains all mails (without attachments) as JSON
  static const String _BOX_MAILS_SENT = 'mails_sent'; // contains all mails (without attachments) as JSON
  static const String _BOX_MAILS_META = 'mails_meta'; // metadata for mails
  static const String _BOX_LOGS_BACKGROUND_TASK = 'logs_background_task'; // tracking background task events for debugging
  static const String _BOX_LOGS_ERROR = 'logs_error'; // tracking errors for debugging

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// initializes hive storage
  /// must be called before first hive access
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(BackgroundTaskAdapter());
    Hive.registerAdapter(LogErrorAdapter());
    await _openBoxSafely<LogError>(_BOX_LOGS_ERROR);
    await _openBoxSafely(_BOX_DEVICE_ID);
    await _openBoxSafely(_BOX_SETTINGS);
    await _openBoxSafely<DateTime>(_BOX_LAST_SYNC);
    await _openBoxSafely<String>(_BOX_API_JSON);
    await _openBoxSafely<Uint8List>(_BOX_API_BINARY);
    await _openBoxSafely<String>(_BOX_MAILS_INBOX);
    await _openBoxSafely<String>(_BOX_MAILS_SENT);
    await _openBoxSafely(_BOX_MAILS_META);
  }

  /// wipes all data except device id
  Future<void> clearData() async {
    await Hive.box(_BOX_SETTINGS).clear();
    await Hive.box<DateTime>(_BOX_LAST_SYNC).clear();
    await Hive.box<String>(_BOX_API_JSON).clear();
    await Hive.box<Uint8List>(_BOX_API_BINARY).clear();
    await Hive.box<String>(_BOX_MAILS_INBOX).clear();
    await Hive.box<String>(_BOX_MAILS_SENT).clear();
    await Hive.box(_BOX_MAILS_META).clear();
    await _secureStorage.deleteAll();
  }

  // device id

  String getDeviceId() {
    return Hive.box(_BOX_DEVICE_ID).get('device_id');
  }

  Future<void> setDeviceId(String deviceId) async {
    await Hive.box(_BOX_DEVICE_ID).put('device_id', deviceId);
  }

  // api storage

  DataWithTimestamp<Uint8List> getApiBinary(String key) {
    final Uint8List binary = Hive.box<Uint8List>(_BOX_API_BINARY).get(key);
    final DateTime timestamp = Hive.box<DateTime>(_BOX_LAST_SYNC).get(key);
    return binary != null && timestamp != null ? DataWithTimestamp(data: binary, timestamp: timestamp) : null;
  }

  Future<void> setApiBinary(String key, DataWithTimestamp<Uint8List> data) async {
    await Hive.box<Uint8List>(_BOX_API_BINARY).put(key, data.data);
    await Hive.box<DateTime>(_BOX_LAST_SYNC).put(key, data.timestamp);
  }

  DataWithTimestamp<String> getApiJson(String key) {
    final String json = Hive.box<String>(_BOX_API_JSON).get(key);
    final DateTime timestamp = Hive.box<DateTime>(_BOX_LAST_SYNC).get(key);
    return json != null && timestamp != null ? DataWithTimestamp(data: json, timestamp: timestamp) : null;
  }

  Future<void> setApiJson(String key, DataWithTimestamp<String> data) async {
    await Hive.box<String>(_BOX_API_JSON).put(key, data.data);
    await Hive.box<DateTime>(_BOX_LAST_SYNC).put(key, data.timestamp);
  }

  DateTime getApiTimestamp(String key) {
    return Hive.box<DateTime>(_BOX_LAST_SYNC).get(key);
  }

  Future<void> deleteApiCache() async {
    await Hive.box<String>(_BOX_API_JSON).clear();
    await Hive.box<Uint8List>(_BOX_API_BINARY).clear();
    await Hive.box<DateTime>(_BOX_LAST_SYNC).clear();
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

  Future<void> setSettings(SettingsData data) async {
    final Box box = Hive.box(_BOX_SETTINGS);
    await box.put('welcome', data.welcome);
    await box.put('locale', data.locale);
    await box.put('favorite_feature_list', data.favorites);
    await box.put('news_channels', data.newsChannels);
    await box.put('calendar_channels', data.calendarChannels);
    await box.put('my_events', data.myEvents);
    await box.put('mensa', describeEnum(data.mensa));
    await box.put('dev_settings', data.devSettings);
    await box.put('dev_server', data.devServer);
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

  DataWithTimestamp<MailCollection> getMails() {
    final timestamp = Hive.box(_BOX_MAILS_META).get('last_update');
    if (timestamp != null) {
      final inbox = Hive.box<String>(_BOX_MAILS_INBOX).toMap().map((key, value) => MapEntry(key, MailMessage.fromMap(json.decode(value))));
      final sent = Hive.box<String>(_BOX_MAILS_SENT).toMap().map((key, value) => MapEntry(key, MailMessage.fromMap(json.decode(value))));
      return DataWithTimestamp(
        data: MailCollection(
          inbox: Map.from(inbox),
          sent: Map.from(sent)
        ),
        timestamp: timestamp
      );
    } else {
      return null;
    }
  }

  Future<void> setMails(DataWithTimestamp<MailCollection> data) async {
    final mailsInbox = data.data.inbox.map((key, value) => MapEntry(key, json.encode(value.toMap())));
    final mailsSent = data.data.sent.map((key, value) => MapEntry(key, json.encode(value.toMap())));

    final boxIn = Hive.box<String>(_BOX_MAILS_INBOX);
    await boxIn.clear();
    await boxIn.putAll(mailsInbox);

    final boxSent = Hive.box<String>(_BOX_MAILS_SENT);
    await boxSent.clear();
    await boxSent.putAll(mailsSent);

    await Hive.box(_BOX_MAILS_META).put('last_update', data.timestamp);
  }

  Future<void> deleteMailCache() async {
    await Hive.box<String>(_BOX_MAILS_INBOX).clear();
    await Hive.box<String>(_BOX_MAILS_SENT).clear();
    await Hive.box(_BOX_MAILS_META).clear();
  }

  Future<List<BackgroundTask>> getBackgroundTasks() async {
    final box = await _openBoxSafely<BackgroundTask>(_BOX_LOGS_BACKGROUND_TASK);
    List<BackgroundTask> tasks = box.values.toList();
    await box.close();
    return tasks;
  }

  Future<void> addBackgroundTask(BackgroundTask task) async {
    final box = await _openBoxSafely<BackgroundTask>(_BOX_LOGS_BACKGROUND_TASK);
    await box.add(task);
    if (box.length > 100) {
      _sliceHalf(box);
      print('Hive: background task box compressed');
    }
    await box.close();
  }

  List<LogError> getErrors() {
    final box = Hive.box<LogError>(_BOX_LOGS_ERROR);
    List<LogError> errors = box.values.toList();
    return errors;
  }

  Future<void> logError(String message, String stacktrace) async {
    final error = LogError()
      ..timestamp = DateTime.now()
      ..message = message
      ..stacktrace = stacktrace;
    final box = Hive.box<LogError>(_BOX_LOGS_ERROR);
    await box.add(error);
    if (box.length > 10) {
      _sliceHalf(box);
    }
  }

  /// closes all boxes
  Future<void> close() async {
    await Hive.close();
    print('Hive closed');
  }

  Future<Box<T>> _openBoxSafely<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      print(e);
      if (boxName != _BOX_LOGS_ERROR) {
        // log error
        String stacktrace;
        if (e is Error) {
          stacktrace = e.stackTrace?.toString();
        }
        await logError(e.toString(), stacktrace);
      }
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox<T>(boxName);
    }
  }

  Future<void> _sliceHalf(Box box) async {
    List keys = box.keys.toList();
    await box.deleteAll(keys.sublist(0, (keys.length / 2).ceil()));
  }
}