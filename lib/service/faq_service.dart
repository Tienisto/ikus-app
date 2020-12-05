import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/data_with_timestamp.dart';
import 'package:ikus_app/model/post_group.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class FAQService implements SyncableService {

  static final FAQService _instance = FAQService();
  static FAQService get instance => _instance;

  DateTime _lastUpdate;
  List<PostGroup> _groups;

  @override
  String getName() => t.sync.items.faq;

  @override
  Future<void> sync({@required bool useNetwork, String useJSON, bool showNotifications}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'faq',
      locale: LocaleSettings.currentLocale,
      useJSON: useJSON,
      useNetwork: useNetwork,
      fallback: []
    );

    List<dynamic> groups = jsonDecode(data.data);
    _groups = groups.map((g) => PostGroup.fromMap(g)).toList().cast<PostGroup>();
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration maxAge = Duration(days: 1);

  @override
  String batchKey = 'FAQ';

  List<PostGroup> getFAQ() {
    return _groups;
  }
}