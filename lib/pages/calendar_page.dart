import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/popups/channel_popup.dart';
import 'package:ikus_app/components/popups/date_popup.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/service/calendar_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/popups.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  CalendarController _calendarController;
  Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = CalendarService.instance.getEventsGroupByDate();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MainListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Row(
              children: [
                Expanded(
                  child: IconText(
                    size: OvguPixels.headerSize,
                    distance: OvguPixels.headerDistance,
                    icon: Icons.today,
                    text: t.main.calendar.title,
                  ),
                ),
                OvguButton(
                  flat: true,
                  type: OvguButtonType.ICON_WIDE,
                  callback: () {
                    List<Channel> channels = CalendarService.instance.getChannels();
                    List<Channel> selected = CalendarService.instance.getSubscribed();
                    Popups.generic(
                        context: context,
                        height: ChannelPopup.calculateHeight(context),
                        body: ChannelPopup(
                          available: channels,
                          selected: selected,
                          callback: (channel, selected) async {
                            if (selected)
                              CalendarService.instance.subscribe(channel);
                            else
                              CalendarService.instance.unsubscribe(channel);
                            setState(() {
                              _events = CalendarService.instance.getEventsGroupByDate();

                              // update again if user changed subscribed channels
                              // _events change -> updated visible events -> nextFrame -> setState
                              nextFrame(() {
                                setState(() {});
                              });
                            });
                          },
                        )
                    );
                  },
                  child: Icon(Icons.filter_list),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: OvguCard(
              child: TableCalendar(
                locale: LocaleSettings.currentLocale,
                calendarController: _calendarController,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonVisible: false,
                ),
                availableGestures: AvailableGestures.none,
                calendarStyle: CalendarStyle(
                  todayColor: OvguColor.primary,
                  highlightSelected: false,
                ),
                events: _events,
                onCalendarCreated: (first, last, format) {
                  nextFrame(() {
                    setState(() {});
                  });
                },
                onVisibleDaysChanged: (first, last, format) { setState(() {}); },
                onDaySelected: (DateTime date, List<dynamic> events) {
                  Popups.generic(
                    context: context,
                    height: 250,
                    body: DatePopup(
                      date: date,
                      events: events.cast<Event>(),
                    )
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: IconText(
              size: OvguPixels.headerSize,
              distance: OvguPixels.headerDistance,
              icon: Icons.list,
              text: t.main.calendar.events,
            ),
          ),
          SizedBox(height: 20),
          ..._calendarController.visibleEvents.entries.map((entry) {
            List<Event> events = entry.value;
            events.sort((a, b) => a.startTime.compareTo(b.startTime));
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(events.first.formattedStartDate, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: events.map((event) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              pushScreen(context, () => EventScreen(event));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.name, style: TextStyle(fontSize: 16)),
                                if (event.hasTime)
                                  Text(event.formattedTime, style: TextStyle(color: OvguColor.secondaryDarken2)),
                                if (!event.hasTime)
                                  SizedBox(height: 10) // placeholder
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
