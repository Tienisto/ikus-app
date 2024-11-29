import 'dart:convert';

import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/audio.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

class AudioService implements SyncableService {

  static final AudioService _instance = AudioService();
  static AudioService get instance => _instance;

  late DateTime _lastUpdate;
  late List<Audio> _audio;

  @override
  String get id => 'AUDIO';

  @override
  String getDescription() => t.sync.items.audio;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
        route: 'audio',
        locale: LocaleSettings.currentLocale.languageTag,
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
  Duration get maxAge => Duration(days: 1);

  @override
  String get batchKey => 'AUDIO';

  List<Audio> getAudio() {
    return _audio;
  }
}