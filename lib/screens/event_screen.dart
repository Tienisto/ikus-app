import 'package:add_2_calendar/add_2_calendar.dart' as calendar;
import 'package:flutter/material.dart';
import 'package:ikus_app/components/badge.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/event_time_card.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/map_with_marker.dart';
import 'package:ikus_app/components/popups/event_added_popup.dart';
import 'package:ikus_app/components/popups/event_past_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/screens/my_events_screen.dart';
import 'package:ikus_app/service/calendar_service.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/popups.dart';
import 'package:ikus_app/utility/ui.dart';

class EventScreen extends StatefulWidget {

  static final TextStyle keyStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static final double valueSize = 20;

  final Event event;

  const EventScreen(this.event);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
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
                child: Text(widget.event.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Badge(text: widget.event.channel.name),
                OvguButton(
                  flat: true,
                  callback: () {

                    if (widget.event.startTime.isBefore(DateTime.now())) {
                      Popups.generic(
                          context: context,
                          height: 220,
                          body: EventPastPopup()
                      );
                      return;
                    }

                    setState(() {
                      CalendarService.instance.toggleMyEvent(widget.event);
                    });

                    if (CalendarService.instance.isMyEvent(widget.event)) {
                      Popups.generic(
                          context: context,
                          height: 220,
                          body: EventAddedPopup(
                            event: widget.event,
                            onOk: () {},
                            onUndo: () {
                              setState(() {
                                CalendarService.instance.toggleMyEvent(widget.event);
                              });
                            },
                            onShowList: () async {
                              await pushScreen(context, () => MyEventsScreen());
                              setState(() {}); // in case user has removed it from the list
                            },
                          )
                      );
                    }
                  },
                  child: Icon(CalendarService.instance.isMyEvent(widget.event) ? Icons.favorite : Icons.favorite_border),
                )
              ],
            ),
          ),
          if (widget.event.info != null)
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 25),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.event.info!, style: TextStyle(fontSize: 16))
              ),
            ),
          SizedBox(height: 20),
          EventTimeCard(
            event: widget.event,
            onAddCalendar: () {
              calendar.Add2Calendar.addEvent2Cal(calendar.Event(
                title: widget.event.name,
                location: widget.event.place ?? '',
                startDate: widget.event.startTime,
                endDate: widget.event.endTime != null ? widget.event.endTime! : widget.event.startTime.hasTime() ? widget.event.startTime.add(Duration(hours: 10)) : widget.event.startTime,
                allDay: !widget.event.startTime.hasTime()
              ));
            }
          ),
          SizedBox(height: 20),
          if (widget.event.place != null || widget.event.coords != null)
            OvguCard(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.event.where, style: EventScreen.keyStyle),
                    if (widget.event.place != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: IconText(
                          size: EventScreen.valueSize,
                          icon: Icons.place,
                          text: widget.event.place!,
                          multiLine: true,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    if (widget.event.coords != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: MapWithMarker(
                          name: widget.event.place,
                          coords: widget.event.coords!,
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
