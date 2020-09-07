import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/contact.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';

class ContactService implements SyncableService {

  static final ContactService _instance = _init();
  static ContactService get instance => _instance;

  DateTime _lastUpdate;
  List<Contact> _contacts;

  static ContactService _init() {
    ContactService service = ContactService();

    service._contacts = [
      Contact("Akademisches Auslandsamt", null, null, "G18", null),
      Contact("IKUS", "ikus@ovgu.de", "+49 (0)391 - 67 515 75", "InterKultiTreff, Walther-Rathenau-Straße 19, 39106 Magdeburg", "Mo. 15-17, Do. 17-19"),
    ];

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.contact;

  @override
  Future<void> sync() async {
    await sleep(500);
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  List<Contact> getContacts() {
    return _contacts;
  }
}