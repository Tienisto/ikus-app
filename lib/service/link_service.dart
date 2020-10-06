import 'dart:convert';

import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/link_group.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class LinkService implements SyncableService {

  static final LinkService _instance = LinkService();
  static LinkService get instance => _instance;

  DateTime _lastUpdate;
  List<LinkGroup> _links;

  @override
  String getName() => t.main.settings.syncItems.links;

  @override
  Future<void> sync({bool useCacheOnly}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'links',
      locale: LocaleSettings.currentLocale,
      useCacheOnly: useCacheOnly,
      fallback: []
    );

    List<dynamic> list = jsonDecode(data.data);
    _links = list.map((group) => LinkGroup.fromMap(group)).toList();
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration getMaxAge() => Duration(days: 1);

  List<LinkGroup> getLinks() {
    return _links;
  }
}