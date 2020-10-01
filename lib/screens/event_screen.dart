import 'package:add_2_calendar/add_2_calendar.dart' as calendar;
import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/map_with_marker.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/utility/ui.dart';

class EventScreen extends StatelessWidget {

  static final TextStyle keyStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static final double valueSize = 20;

  final Event event;

  const EventScreen(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.event.title),
      ),
      body: MainListView(
        padding: OvguPixels.mainScreenPadding,
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(event.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ),
          ),
          if (event.info != null)
            SizedBox(height: 20),
          if (event.info != null)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(event.info, style: TextStyle(fontSize: 16))
              ),
            ),
          SizedBox(height: 20),
          OvguCard(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.event.when, style: keyStyle),
                        SizedBox(height: 10),
                        IconText(
                          size: valueSize,
                          icon: Icons.event,
                          text: event.formattedStartDateWithWeekday,
                        ),
                        if(event.hasTime)
                          SizedBox(height: 10),
                        if(event.hasTime)
                          IconText(
                            size: valueSize,
                            icon: Icons.access_time,
                            text: event.formattedTime,
                          ),
                      ],
                    ),
                  ),
                  OvguButton(
                    type: OvguButtonType.ICON_WIDE,
                    callback: () {
                      calendar.Add2Calendar.addEvent2Cal(calendar.Event(
                          title: event.name,
                          location: event.place,
                          startDate: event.startTime,
                          endDate: event.hasEndTime ? event.endTime : event.hasTime ? event.startTime.add(Duration(hours: 10)) : event.startTime,
                          allDay: !event.hasTime
                      ));
                    },
                    child: Icon(Icons.add_alert, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          if (event.place != null || event.coords != null)
            OvguCard(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.event.where, style: keyStyle),
                    if (event.place != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: IconText(
                          size: valueSize,
                          icon: Icons.place,
                          text: event.place,
                          multiLine: true,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    if (event.coords != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: MapWithMarker(
                          name: event.place,
                          coords: event.coords,
                        ),
                      )
                  ],
                ),
              ),
            ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
