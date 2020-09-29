import 'dart:convert';

import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/mensa_info.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class MensaService implements SyncableService {

  static final MensaService _instance = MensaService();
  static MensaService get instance => _instance;

  DateTime _lastUpdate;
  List<MensaInfo> _menu;

  @override
  String getName() => t.main.settings.syncItems.mensa;

  @override
  Future<void> sync({bool useCacheOnly}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'mensa',
      locale: LocaleSettings.currentLocale,
      useCache: useCacheOnly,
      fallback: []
    );

    List<dynamic> list = jsonDecode(data.data);
    _menu = list.map((mensa) => MensaInfo.fromMap(mensa))
        .where((mensa) => mensa.name != null)
        .toList();
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration getMaxAge() => Duration(hours: 1);

  List<MensaInfo> getMenu() {
    return _menu;
  }
}