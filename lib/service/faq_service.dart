import 'dart:convert';

import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/post_group.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

class FAQService implements SyncableService {

  static final FAQService _instance = FAQService();
  static FAQService get instance => _instance;

  late DateTime _lastUpdate;
  late List<PostGroup> _groups;

  @override
  String id = 'FAQ';

  @override
  String getDescription() => t.sync.items.faq;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'faq',
      locale: LocaleSettings.currentLocale.languageTag,
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