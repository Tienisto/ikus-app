import 'dart:convert';

import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/link_group.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

class LinkService implements SyncableService {

  static final LinkService _instance = LinkService();
  static LinkService get instance => _instance;

  late DateTime _lastUpdate;
  late List<LinkGroup> _links;

  @override
  String id = 'LINKS';

  @override
  String getDescription() => t.sync.items.links;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'links',
      locale: LocaleSettings.currentLocale.languageTag,
      useJSON: useJSON,
      useNetwork: useNetwork,
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
  Duration maxAge = Duration(days: 1);

  @override
  String batchKey = 'LINKS';

  List<LinkGroup> getLinks() {
    return _links;
  }
}