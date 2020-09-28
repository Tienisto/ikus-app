import 'dart:convert';

import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/post_group.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class FAQService implements SyncableService {

  static final FAQService _instance = FAQService();
  static FAQService get instance => _instance;

  DateTime _lastUpdate;
  List<PostGroup> _groups;

  @override
  String getName() => t.main.settings.syncItems.faq;

  @override
  Future<void> sync({bool useCache}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'faq',
      locale: LocaleSettings.currentLocale,
      useCache: useCache,
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

  List<PostGroup> getFAQ() {
    return _groups;
  }
}