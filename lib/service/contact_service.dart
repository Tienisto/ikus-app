import 'dart:convert';

import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/contact.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class ContactService implements SyncableService {

  static final ContactService _instance = ContactService();
  static ContactService get instance => _instance;

  DateTime _lastUpdate;
  List<Contact> _contacts;

  @override
  String getName() => t.main.settings.syncItems.contact;

  @override
  Future<void> sync({bool useCacheOnly}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'contacts',
      locale: LocaleSettings.currentLocale,
      useCache: useCacheOnly,
      fallback: []
    );

    List<dynamic> list = jsonDecode(data.data);

    _contacts = list.map((contact) => Contact.fromMap(contact)).toList();
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  List<Contact> getContacts() {
    return _contacts;
  }
}