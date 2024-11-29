import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/rotating.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:intl/intl.dart';

class SyncScreen extends StatefulWidget {
  @override
  _SyncScreenState createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {

  static const String LOG_NAME = 'SyncScreen';
  static DateFormat _dateFormatterDe = DateFormat("dd.MM.yyyy, HH:mm");
  static DateFormat _dateFormatterEn = DateFormat("dd.MM.yyyy, h:mm a");
  Map<String, bool> syncing = Map();

  Widget getSyncItem(String name, DateTime lastUpdate, FutureCallback callback) {
    return Row(
      children: [
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(LocaleSettings.currentLocale == AppLocale.en ? _dateFormatterEn.format(lastUpdate) : _dateFormatterDe.format(lastUpdate))
              ],
            )
        ),
        OvguButton(
          flat: true,
          callback: () async {
            if (syncing[name] == true) {
              log('$name is already syncing', name: LOG_NAME);
              return;
            }
            syncing[name] = true; // not inside setState to lock immediately
            setState(() {});
            await callback();
            if (!mounted)
              return;
            setState(() {
              syncing[name] = false;
            });
          },
          child: syncing[name] == true ? Rotating(child: Icon(Icons.sync)) : Icon(Icons.sync),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(t.sync.title)
      ),
      body: MainListView(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(t.sync.info, style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: OvguCard(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 5, right: 5, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: SyncableService.services.map((service) {
                      return getSyncItem(service.getDescription(), service.getLastUpdate(), () async {
                        await service.sync(useNetwork: true, showNotifications: true);
                      });
                    }).toList()
                ),
              ),
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
