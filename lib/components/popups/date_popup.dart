import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class DatePopup extends StatelessWidget {
  final Callback onEventPop;
  final DateTime date;
  final List<Event> events;

  const DatePopup({required this.date, required this.events, required this.onEventPop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10),
              child: Text(Event.formatDate(date), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            OvguButton(
              flat: true,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              callback: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            ),
          ],
        ),
        SizedBox(height: 20),
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(t.popups.date.empty, style: TextStyle(fontSize: 16)),
          ),
        if (events.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(t.popups.date.normal, style: TextStyle(fontSize: 16)),
          ),
        if (events.isNotEmpty)
          Expanded(
            child: ListView(
              physics: Adaptive.getScrollPhysics(),
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 20),
              children: events.map((event) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OvguColor.primary,
                      shape: OvguPixels.shape,
                      elevation: OvguPixels.elevation,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await pushScreen(context, () => EventScreen(event));
                      onEventPop();
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            event.name,
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                          if (event.startTime.hasTime())
                            IconText(
                              size: 14,
                              icon: Icons.access_time,
                              text: t.timeFormat(time: event.formattedSameDayTime),
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
