import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/contact_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/contact.dart';
import 'package:ikus_app/service/contact_service.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<Contact> contacts = ContactService.instance.getContacts();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.contacts.title)
      ),
      body: MainListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          ...contacts.map((contact) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ContactCard(contact),
          ))
        ],
      ),
    );
  }
}
