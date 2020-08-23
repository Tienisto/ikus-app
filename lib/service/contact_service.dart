import 'package:ikus_app/model/contact.dart';

class ContactService {

  static List<Contact> _contacts = [
    Contact("Akademisches Auslandsamt", null, null, "G18", null),
    Contact("IKUS", "ikus@ovgu.de", "+49 (0)391 - 67 515 75", "InterKultiTreff, Walther-Rathenau-Straße 19, 39106 Magdeburg", "Mo. 15-17, Do. 17-19"),
  ];

  static List<Contact> getContacts() {
    return _contacts;
  }
}