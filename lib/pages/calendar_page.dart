import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/service/event_service.dart';
import 'package:ikus_app/utility/globals.dart';
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
    _events = EventService.getEventsGroupByDate();
  }

  @override
  void dispose() {
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: IconText(
              size: OvguPixels.headerSize,
              distance: OvguPixels.headerDistance,
              icon: Icons.today,
              text: t.main.calendar.title,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Card(
              color: OvguColor.secondary,
              shape: OvguPixels.shape,
              elevation: OvguPixels.elevation,
              child: TableCalendar(
                locale: LocaleSettings.currentLocale == '' ? 'en' : LocaleSettings.currentLocale,
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
            events.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(events.first.getFormattedDate(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: events.map((event) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.name, style: TextStyle(fontSize: 16)),
                            if (event.hasTime())
                              Text(event.getFormattedTime(), style: TextStyle(color: OvguColor.secondaryDarken)),
                          ],
                        ),
                      );
                    }).toList(),
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