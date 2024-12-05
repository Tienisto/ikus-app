import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ikus_app/model/local/background_task.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/local/event_registration_data.dart';
import 'package:ikus_app/model/local/log_error.dart';
import 'package:ikus_app/model/local/mail_metadata.dart';
import 'package:ikus_app/model/local/ovgu_account.dart';
import 'package:ikus_app/model/local/settings_data.dart';
import 'package:ikus_app/model/mail/mail_collection.dart';
import 'package:ikus_app/model/mail/mail_message.dart';
import 'package:ikus_app/model/mail/mailbox_type.dart';
import 'package:ikus_app/model/mensa_info.dart';

/// manages hive (persistent) storage and secure storage
/// no class except this class has dependency to hive or secure storage
class PersistentService {

  static const String LOG_NAME = 'Persistence';
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
  }

  /// wipes all data except device id and logs
  Future<void> clearData() async {
    await Hive.box(_BOX_SETTINGS).clear();
    await deleteMailCache();
    await deleteApiCache();
    await _secureStorage.deleteAll();
  }

  // device id

  String? getDeviceId() {
    return Hive.box(_BOX_DEVICE_ID).get('device_id');
  }

  Future<void> setDeviceId(String deviceId) async {
    await Hive.box(_BOX_DEVICE_ID).put('device_id', deviceId);
  }

  // api storage

  Future<DataWithTimestamp<Uint8List>?> getApiBinary(String key) async {
    final boxBinary = await _openLazyBoxSafely<Uint8List>(_BOX_API_BINARY);
    final boxLastSync = await _openLazyBoxSafely<DateTime>(_BOX_LAST_SYNC);
    final Uint8List? binary = await boxBinary.get(key);
    final DateTime? timestamp = await boxLastSync.get(key);
    final result = binary != null && timestamp != null ? DataWithTimestamp(data: binary, timestamp: timestamp) : null;
    await boxBinary.close();
    await boxLastSync.close();
    return result;
  }

  Future<void> setApiBinary(String key, DataWithTimestamp<Uint8List> data) async {
    final boxBinary = await _openLazyBoxSafely<Uint8List>(_BOX_API_BINARY);
    final boxLastSync = await _openLazyBoxSafely<DateTime>(_BOX_LAST_SYNC);
    await boxBinary.put(key, data.data);
    await boxLastSync.put(key, data.timestamp);
    await boxBinary.close();
    await boxLastSync.close();
  }

  Future<DataWithTimestamp<String>?> getApiJson(String key) async {
    final boxJson = await _openLazyBoxSafely<String>(_BOX_API_JSON);
    final boxLastSync = await _openLazyBoxSafely<DateTime>(_BOX_LAST_SYNC);
    final String? json = await boxJson.get(key);
    final DateTime? timestamp = await boxLastSync.get(key);
    final result = json != null && timestamp != null ? DataWithTimestamp(data: json, timestamp: timestamp) : null;
    await boxJson.close();
    await boxLastSync.close();
    return result;
  }

  Future<void> setApiJson(String key, DataWithTimestamp<String> data) async {
    final boxJson = await _openLazyBoxSafely<String>(_BOX_API_JSON);
    final boxLastSync = await _openLazyBoxSafely<DateTime>(_BOX_LAST_SYNC);
    await boxJson.put(key, data.data);
    await boxLastSync.put(key, data.timestamp);
    await boxJson.close();
    await boxLastSync.close();
  }

  Future<DateTime?> getApiTimestamp(String key) async {
    final boxLastSync = await _openLazyBoxSafely<DateTime>(_BOX_LAST_SYNC);
    final result = boxLastSync.get(key);
    await boxLastSync.close();
    return result;
  }

  Future<void> deleteApiCache() async {
    final boxJson = await _openLazyBoxSafely<String>(_BOX_API_JSON);
    final boxBinary = await _openLazyBoxSafely<Uint8List>(_BOX_API_BINARY);
    final boxLastSync = await _openLazyBoxSafely<DateTime>(_BOX_LAST_SYNC);
    await boxJson.clear();
    await boxBinary.clear();
    await boxLastSync.clear();
    await boxJson.close();
    await boxBinary.close();
    await boxLastSync.close();
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
      myEventsNotified2h: box
          .get('my_events_notified_2h', defaultValue: [])
          .cast<int>(),
      mensa: (box.get('mensa') as String?)?.toMensa() ?? Mensa.UNI_CAMPUS_DOWN,
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
    await box.put('my_events_notified_2h', data.myEventsNotified2h);
    await box.put('mensa', data.mensa.name);
    await box.put('dev_settings', data.devSettings);
    await box.put('dev_server', data.devServer);
  }

  // ovgu account

  Future<OvguAccount?> getOvguAccount() async {
    String? ovguName = await _secureStorage.read(key: 'ovgu_name');
    String? ovguPassword = await _secureStorage.read(key: 'ovgu_password');
    String? mailAddress = await _secureStorage.read(key: 'ovgu_mail_address');
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

  // event registrations

  Future<EventRegistrationData> getEventRegistrationData() async {
    final eventRegistrationData = await _secureStorage.read(key: 'e_registration_data');
    if (eventRegistrationData != null) {
      return EventRegistrationData.fromMap(json.decode(eventRegistrationData));
    } else {
      return EventRegistrationData(
        matriculationNumber: null,
        firstName: null,
        lastName: null,
        email: null,
        address: null,
        country: null,
        registrationTokens: {}
      );
    }
  }

  Future<void> setEventRegistrationData(EventRegistrationData data) async {
    await _secureStorage.write(key: 'e_registration_data', value: json.encode(data.toMap()));
  }

  // mails

  Future<MailCollection> getAllMails() async {
    final boxInbox = await _openBoxSafely<String>(_BOX_MAILS_INBOX);
    final boxSent = await _openBoxSafely<String>(_BOX_MAILS_SENT);
    final inbox = boxInbox.toMap().map((key, value) => MapEntry(key, MailMessage.fromMap(json.decode(value))));
    final sent = boxSent.toMap().map((key, value) => MapEntry(key, MailMessage.fromMap(json.decode(value))));
    final mails = MailCollection(
        inbox: Map.from(inbox),
        sent: Map.from(sent)
    );

    await boxInbox.close();
    await boxSent.close();
    return mails;
  }

  /// used to display mails
  /// only show a part of the collection to improve performance
  /// order of keys are reversed
  Future<List<MailMessage>> getMails({required MailboxType mailbox, required int startIndex, required int size}) async {
    final box = await _openLazyBoxSafely<String>(mailbox == MailboxType.INBOX ? _BOX_MAILS_INBOX : _BOX_MAILS_SENT);

    // get keys
    final keys = box.keys.toList().reversed.toList();
    final selectedKeys = <int>[];
    for (int i = startIndex; i < keys.length && i < startIndex + size; i++) {
      selectedKeys.add(keys[i]);
    }

    // get mails using the keys
    final mails = <MailMessage>[];
    for (int key in selectedKeys) {
      final mail = await box.get(key);
      if (mail != null) {
        mails.add(MailMessage.fromMap(json.decode(mail)));
      }
    }

    await box.close();
    return mails;
  }

  /// returns a specific mail by uid
  /// may be null
  Future<MailMessage?> getMail(MailboxType mailbox, int uid) async {
    final box = await _openLazyBoxSafely<String>(mailbox == MailboxType.INBOX ? _BOX_MAILS_INBOX : _BOX_MAILS_SENT);
    final mailRaw = await box.get(uid);
    MailMessage? message;
    if (mailRaw != null) {
      message = MailMessage.fromMap(json.decode(mailRaw));
    }
    await box.close();
    return message;
  }

  Future<MailMetadata> getMailMetadata() async {
    final boxInbox = await _openLazyBoxSafely<String>(_BOX_MAILS_INBOX);
    final boxSent = await _openLazyBoxSafely<String>(_BOX_MAILS_SENT);
    final boxMeta = await _openBoxSafely(_BOX_MAILS_META);
    final metadata = MailMetadata(
      timestamp: boxMeta.get('last_update'),
      countInbox: boxInbox.length,
      countSent: boxSent.length
    );
    await boxInbox.close();
    await boxSent.close();
    await boxMeta.close();
    return metadata;
  }

  Future<void> setMails(DataWithTimestamp<MailCollection> data) async {
    final mailsInbox = data.data.inbox.map((key, value) => MapEntry(key, json.encode(value.toMap())));
    final mailsSent = data.data.sent.map((key, value) => MapEntry(key, json.encode(value.toMap())));

    final boxInbox = await _openLazyBoxSafely<String>(_BOX_MAILS_INBOX);
    final boxSent = await _openLazyBoxSafely<String>(_BOX_MAILS_SENT);
    final boxMeta = await _openLazyBoxSafely(_BOX_MAILS_META);

    await boxInbox.clear();
    await boxInbox.putAll(mailsInbox);

    await boxSent.clear();
    await boxSent.putAll(mailsSent);

    await boxMeta.put('last_update', data.timestamp);

    await boxInbox.close();
    await boxSent.close();
    await boxMeta.close();
  }

  Future<void> deleteMailCache() async {
    final boxInbox = await _openLazyBoxSafely<String>(_BOX_MAILS_INBOX);
    final boxSent = await _openLazyBoxSafely<String>(_BOX_MAILS_SENT);
    final boxMeta = await _openLazyBoxSafely(_BOX_MAILS_META);
    await boxInbox.clear();
    await boxSent.clear();
    await boxMeta.clear();
    await boxInbox.close();
    await boxSent.close();
    await boxMeta.close();
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

  Future<void> logError(String message, String? stacktrace) async {
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
    log('Hive closed', name: LOG_NAME);
  }

  Future<Box<T>> _openBoxSafely<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      await _handleOpenBoxError(boxName, e);
      return await Hive.openBox<T>(boxName);
    }
  }

  Future<LazyBox<T>> _openLazyBoxSafely<T>(String boxName) async {
    try {
      return await Hive.openLazyBox<T>(boxName);
    } catch (e) {
      await _handleOpenBoxError(boxName, e);
      return await Hive.openLazyBox<T>(boxName);
    }
  }

  /// write entry to error log box
  /// delete contents of failed box
  Future<void> _handleOpenBoxError(String boxName, e) async {
    print(e);
    if (boxName != _BOX_LOGS_ERROR) {
      // log error
      String? stacktrace;
      if (e is Error) {
        stacktrace = e.stackTrace?.toString();
      }
      await logError(e.toString(), stacktrace);
    }
    await Hive.deleteBoxFromDisk(boxName);
  }

  Future<void> _sliceHalf(Box box) async {
    List keys = box.keys.toList();
    await box.deleteAll(keys.sublist(0, (keys.length / 2).ceil()));
  }
}