import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/event_list.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/service/calendar_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class MyEventsScreen extends StatefulWidget {

  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {

  Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() {
    _events = CalendarService.instance.getMyEventsGrouped();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.myEvents.title)
      ),
      body: MainListView(
        padding: OvguPixels.mainScreenPadding,
        children: [
          SizedBox(height: 20),
          OvguCard(
            child: Padding(
              padding: EdgeInsets.all(10),
                child: Text(t.myEvents.info, style: TextStyle(fontSize: 16))
            )
          ),
          SizedBox(height: 20),
          EventList(
            events: _events,
            highlighted: [],
            callback: (event) async {
              await pushScreen(context, () => EventScreen(event));
              setState(() {
                _updateData();
              });
            },
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
