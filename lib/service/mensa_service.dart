import 'dart:convert';

import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/mensa_info.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

class MensaService implements SyncableService {

  static final MensaService _instance = MensaService();
  static MensaService get instance => _instance;

  late DateTime _lastUpdate;
  late List<MensaInfo> _menu;

  @override
  String id = 'MENSA';

  @override
  String getDescription() => t.sync.items.mensa;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'mensa',
      locale: LocaleSettings.currentLocale.languageTag,
      useNetwork: useNetwork,
      useJSON: useJSON,
      fallback: []
    );

    List<dynamic> list = jsonDecode(data.data);
    _menu = list.map((mensa) => MensaInfo.fromMap(mensa)).toList();
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration maxAge = Duration(hours: 1);

  @override
  String batchKey = 'MENSA';

  List<MensaInfo> getMenu() {
    return _menu;
  }
}