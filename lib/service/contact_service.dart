import 'dart:convert';

import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/contact.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';

class ContactService implements SyncableService {

  static final ContactService _instance = ContactService();
  static ContactService get instance => _instance;

  late DateTime _lastUpdate;
  late List<Contact> _contacts;

  @override
  String id = 'CONTACT';

  @override
  String getDescription() => t.sync.items.contact;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'contacts',
      locale: LocaleSettings.currentLocale.languageTag,
      useJSON: useJSON,
      useNetwork: useNetwork,
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

  @override
  Duration maxAge = Duration(days: 1);

  @override
  String batchKey = 'CONTACTS';

  List<Contact> getContacts() {
    return _contacts;
  }
}