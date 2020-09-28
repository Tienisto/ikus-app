import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/contact.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';

class ContactService implements SyncableService {

  static final ContactService _instance = _init();
  static ContactService get instance => _instance;

  DateTime _lastUpdate;
  List<Contact> _contacts;

  static ContactService _init() {
    ContactService service = ContactService();

    service._contacts = [
      Contact(name: "Akademisches Auslandsamt", image: null, email: null, phoneNumber: null, place: "G18", openingHours: null),
      Contact(name: "IKUS", image: Image.network('https://www.studentenwerk-magdeburg.de/wp-content/uploads/2020/06/IKUS_Logo-600x600.jpg'), email: "ikus@ovgu.de", phoneNumber: "+49 (0)391 - 67 515 75", place: "InterKultiTreff\nWalther-Rathenau-Straße 19\n39106 Magdeburg", openingHours: "Mo. 15-17, Do. 17-19"),
    ];

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.contact;

  @override
  Future<void> sync({bool useCache}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'contacts',
      locale: LocaleSettings.currentLocale,
      useCache: useCache,
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