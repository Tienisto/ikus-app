import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/event_list.dart';
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

  late CalendarController _calendarController;
  late Map<DateTime, List<Event>> _events;
  late List<Event> _myEvents;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _updateData();
  }

  void _updateData() {
    _events = CalendarService.instance.getEventsGroupByDate();
    _myEvents = CalendarService.instance.getMyEvents();
  }

  void _updateDataWithSetState() {
    setState(() {
      _updateData();
      nextFrame(() {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
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
                            _updateDataWithSetState();
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
                onDaySelected: (DateTime date, List<dynamic> events, _) {
                  Popups.generic(
                    context: context,
                    height: events.length >= 3 ? 275 : 250,
                    body: DatePopup(
                      date: date,
                      events: events.cast<Event>(),
                      onEventPop: () {
                        // in case that register information has changed
                        _updateDataWithSetState();
                      },
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: EventList(
              events: _calendarController.visibleEvents
                  .map((key, value) => MapEntry(key, [...value].cast<Event>()))
                  ..removeWhere((key, value) {
                    value.removeWhere((event) => !CalendarService.instance.isInFuture(event, now));
                    return value.isEmpty;
                  }),
              highlighted: _myEvents,
              callback: (event) async {
                await pushScreen(context, () => EventScreen(event));
                _updateDataWithSetState();
              },
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
