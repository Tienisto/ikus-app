import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/data_with_timestamp.dart';
import 'package:ikus_app/model/link_group.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class LinkService implements SyncableService {

  static final LinkService _instance = LinkService();
  static LinkService get instance => _instance;

  DateTime _lastUpdate;
  List<LinkGroup> _links;

  @override
  String getName() => t.sync.items.links;

  @override
  Future<void> sync({@required bool useNetwork, String useJSON, bool showNotifications}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'links',
      locale: LocaleSettings.currentLocale,
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