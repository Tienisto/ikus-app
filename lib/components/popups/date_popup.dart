import 'package:flutter/material.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class DatePopup extends StatelessWidget {

  final DateTime date;
  final List<Event> events;

  const DatePopup({@required this.date, @required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: Adaptive.getScrollPhysics(),
      padding: EdgeInsets.all(15),
      children: [
        Text(Event.formatOnlyDate.format(date), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        if (events.isEmpty)
          Text(t.popups.datePopup.empty, style: TextStyle(fontSize: 16)),
        if (events.isNotEmpty)
          Text(t.popups.datePopup.normal, style: TextStyle(fontSize: 16)),
        if (events.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: events.map((event) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 50,
                  child: RaisedButton(
                    color: OvguColor.primary,
                    shape: OvguPixels.shape,
                    elevation: OvguPixels.elevation,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    onPressed: () {
                      pushScreen(context, () => EventScreen(event));
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(event.name, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          if (event.hasTime)
                            IconText(
                              size: 14,
                              icon: Icons.access_time,
                              text: event.formattedTime,
                              color: Colors.white,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )
      ],
    );
  }
}
