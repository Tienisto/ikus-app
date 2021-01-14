import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/audio.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

class AudioService implements SyncableService {

  static final AudioService _instance = AudioService();
  static AudioService get instance => _instance;

  DateTime _lastUpdate;
  List<Audio> _audio;

  @override
  String id = 'AUDIO';

  @override
  String getDescription() => t.sync.items.audio;

  @override
  Future<void> sync({@required bool useNetwork, String useJSON, bool showNotifications = false, AddFutureCallback onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
        route: 'audio',
        locale: LocaleSettings.currentLocale,
        useJSON: useJSON,
        useNetwork: useNetwork,
        fallback: []
    );

    List<dynamic> list = jsonDecode(data.data);

    _audio = list.map((audio) => Audio.fromMap(audio)).toList();
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration maxAge = Duration(days: 1);

  @override
  String batchKey = 'AUDIO';

  List<Audio> getAudio() {
    return _audio;
  }
}