import 'package:flutter/material.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class EventList extends StatelessWidget {

  final Map<DateTime, List<Event>> events;
  final List<Event> highlighted;

  const EventList({@required this.events, @required this.highlighted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: events.entries.map((entry) {
        List<Event> events = entry.value;
        events.sort((a, b) => a.startTime.compareTo(b.startTime));
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(events.first.formattedStartDate, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: events.map((event) {
                    bool currHighlighted = highlighted.any((e) => e.id == event.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          pushScreen(context, () => EventScreen(event));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.name, style: TextStyle(fontSize: 16, fontWeight: currHighlighted ? FontWeight.bold : FontWeight.normal)),
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
    );
  }
}
