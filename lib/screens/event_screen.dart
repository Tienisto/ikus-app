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
import 'package:ikus_app/components/popups/event_unregister_popup.dart';
import 'package:ikus_app/components/popups/generic_text_popup.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/screens/my_events_screen.dart';
import 'package:ikus_app/screens/register_event_screen.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/calendar_service.dart';
import 'package:ikus_app/utility/crypto.dart';
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

  late Event event;
  int? registrationPosition;
  String? registrationToken;

  @override
  void initState() {
    super.initState();
    event = widget.event;
    calculateRegistration();
  }

  void calculateRegistration() {
    registrationPosition = null;
    registrationToken = null;

    final registration = CalendarService.instance
        .getEventRegistrationData()
        .registrationTokens[event.id];
    if (registration != null) {
      final hash = Crypto.hashSHA256(registration);
      for (int i = 0; i < event.registrations.length; i++) {
        if (event.registrations[i] == hash) {
          registrationPosition = i;
          registrationToken = registration;
        }
      }
    }
  }

  Future<void> unregister() async {
    final token = registrationToken;
    if (token == null)
      return;

    DateTime start = DateTime.now();
    GenericTextPopup.open(context: context, text: t.event.registration.canceling);

    final success = await ApiService.unregisterEvent(
        eventId: event.id,
        token: token,
    );

    if (success) {
      await CalendarService.instance.deleteEventRegistrationToken(event.id);
    }

    await CalendarService.instance.sync(useNetwork: true);
    setState(() {
      event = CalendarService.instance.getEvents().firstWhere((e) => e.id == event.id, orElse: () => event);
      calculateRegistration();
    });

    // at least 1sec popup time
    await sleepRemaining(1000, start);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final Color registrationColor;
    final String registrationStatus;
    if (registrationPosition != null) {
      if (registrationPosition! < event.registrationSlots) {
        registrationStatus = t.event.registration.status.registered;
        registrationColor = Colors.green;
      } else {
        registrationStatus = t.event.registration.status.waitingList(position: (registrationPosition! - event.registrationSlots + 1));
        registrationColor = Colors.orange;
      }
    } else if (event.registrationOpen) {
      if (event.registrations.length >= event.registrationSlots) {
        registrationStatus = t.event.registration.status.full;
        registrationColor = Colors.orange;
      } else {
        registrationStatus = t.event.registration.status.open;
        registrationColor = Colors.green;
      }
    } else {
      registrationStatus = t.event.registration.status.closed;
      registrationColor = Colors.grey;
    }

    return Scaffold(
      appBar: AppBar(
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
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                IkusBadge(text: event.channel.name),
                OvguButton(
                  flat: true,
                  callback: () {

                    if (event.startTime.isBefore(DateTime.now())) {
                      Popups.generic(
                          context: context,
                          height: 220,
                          body: EventPastPopup()
                      );
                      return;
                    }

                    setState(() {
                      CalendarService.instance.toggleMyEvent(event);
                    });

                    if (CalendarService.instance.isMyEvent(event)) {
                      Popups.generic(
                          context: context,
                          height: 220,
                          body: EventAddedPopup(
                            event: event,
                            onOk: () {},
                            onUndo: () {
                              setState(() {
                                CalendarService.instance.toggleMyEvent(event);
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
                  child: Icon(CalendarService.instance.isMyEvent(event) ? Icons.favorite : Icons.favorite_border),
                )
              ],
            ),
          ),
          if (event.info != null)
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 25),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(event.info!, style: TextStyle(fontSize: 16))
              ),
            ),
          if (event.registrationOpen || event.registrations.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: OvguCard(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.event.registration.title, style: EventScreen.keyStyle),
                      SizedBox(height: 10),
                      IconText(size: 20, icon: Icons.people, text: t.event.registration.slots(registered: event.registrations.length, slots: event.registrationSlots)),
                      SizedBox(height: 10),
                      IconText(size: 20, icon: Icons.info, text: registrationStatus, color: registrationColor),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          if (registrationPosition == null)
                            OvguButton(
                              callback: () async {
                                await pushScreen(context, () => RegisterEventScreen(eventId: event.id, requiredFields: event.registrationFields));
                                setState(() {
                                  event = CalendarService.instance.getEvents().firstWhere((e) => e.id == event.id, orElse: () => event);
                                  calculateRegistration();
                                });
                              },
                              child: Text(t.event.registration.register, style: TextStyle(color: Colors.white))
                            ),
                          if (registrationPosition != null)
                            OvguButton(
                                callback: () {
                                  EventUnregisterPopup.open(context: context, callback: () {
                                    Navigator.pop(context);
                                    unregister();
                                  });
                                },
                                child: Text(t.event.registration.cancel, style: TextStyle(color: Colors.white))
                            )
                        ],
                      )
                    ],
                  ),
                )
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: EventTimeCard(
              event: event,
              onAddCalendar: () {
                calendar.Add2Calendar.addEvent2Cal(calendar.Event(
                  title: event.name,
                  location: event.place ?? '',
                  startDate: event.startTime,
                  endDate: event.endTime != null ? event.endTime! : event.startTime.hasTime() ? event.startTime.add(Duration(hours: 10)) : event.startTime,
                  allDay: !event.startTime.hasTime()
                ));
              }
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
                    Text(t.event.where, style: EventScreen.keyStyle),
                    if (event.place != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: IconText(
                          size: EventScreen.valueSize,
                          icon: Icons.place,
                          text: event.place!,
                          multiLine: true,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    if (event.coords != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: MapWithMarker(
                          name: event.place,
                          coords: event.coords!,
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
