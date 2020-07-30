import 'package:ikus_app/model/event.dart';

class EventService {

  static List<Event> getEvents() {
    return [
      Event("Immatrikulationsfeier", DateTime(2020, 7, 2, 19), "Festung Mark"),
      Event("Wohnheim-Spieleabend", DateTime(2020, 7, 2, 20), "Campus Theater"),
      Event("Grillen", DateTime(2020, 7, 6, 16), "vor Gebäude 16"),
      Event("Immatrikulationsfeier", DateTime(2020, 8, 2, 19), "Festung Mark"),
      Event("Wohnheim-Spieleabend", DateTime(2020, 8, 5, 20), "Campus Theater"),
      Event("Grillen", DateTime(2020, 8, 6, 16), "vor Gebäude 16"),
      Event("Immatrikulationsfeier", DateTime(2020, 8, 6, 20), "vor Gebäude 16"),
      Event("Immatrikulationsfeier", DateTime(2020, 8, 7), "vor Gebäude 16"),
      Event("Grillen", DateTime(2020, 8, 7), "vor Gebäude 16")
    ];
  }

  static Map<DateTime, List<Event>> getEventsGroupByDate() {
    List<Event> events = getEvents();
    Map<DateTime, List<Event>> map = Map();
    events.forEach((event) {
      DateTime date = DateTime(event.timestamp.year, event.timestamp.month, event.timestamp.day);
      List<Event> currEvents = map[date];
      if (currEvents != null) {
        currEvents.add(event);
      } else {
        map[date] = [event];
      }
    });

    return map;
  }

  static List<Event> getNextEvents() {
    return [
      Event("Immatrikulationsfeier", DateTime(2020, 8, 2, 19), "Festung Mark"),
      Event("Wohnheim-Spieleabend", DateTime(2020, 8, 5, 20), "Campus Theater"),
      Event("Grillen", DateTime(2020, 8, 6, 16), "vor Gebäude 16")
    ];
  }
}