import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/extensions.dart';

class EventTimeCard extends StatelessWidget {

  final Event event;
  final Callback onAddCalendar;

  const EventTimeCard({required this.event, required this.onAddCalendar});

  Widget getAddCalendarButton() {
    return OvguButton(
      callback: onAddCalendar,
      child: Icon(Icons.add_alert, color: Colors.white),
    );
  }

  Widget getContent() {
    if (event.endTime == null || event.endTime!.isSameDay(event.startTime)) {
      /*
       * one day format:
       * - date
       * - time
       */
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.event.when, style: EventScreen.keyStyle),
                SizedBox(height: 10),
                IconText(
                  size: EventScreen.valueSize,
                  icon: Icons.event,
                  text: Event.formatDate(event.startTime, weekday: true),
                ),
                if(event.startTime.hasTime())
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconText(
                      size: EventScreen.valueSize,
                      icon: Icons.access_time,
                      text: t.timeFormat(time: event.formattedSameDayTime),
                    ),
                  ),
              ],
            ),
          ),
          getAddCalendarButton()
        ],
      );
    } else {
      /*
       * multiple days format:
       * - from timestamp
       * - to timestamp
       */
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.event.when, style: EventScreen.keyStyle),
          SizedBox(height: 10),
          Text(Event.formatFull(event.startTime, weekday: true), style: TextStyle(fontSize: EventScreen.valueSize)),
          SizedBox(height: 10),
          Text(t.event.to),
          SizedBox(height: 10),
          Text(Event.formatFull(event.endTime!, weekday: true), style: TextStyle(fontSize: EventScreen.valueSize)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OvguButton(
                callback: onAddCalendar,
                child: Icon(Icons.add_alert, color: Colors.white),
              )
            ],
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OvguCard(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: getContent(),
      ),
    );
  }
}
