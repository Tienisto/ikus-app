import 'package:ikus_app/model/event.dart';
import "package:latlong/latlong.dart";

class EventService {

  static LatLng _coords = LatLng(52.137813, 11.646508);
  static List<Event> getEvents() {
    return [
      Event("Immatrikulationsfeier", DateTime(2020, 7, 2, 19), null, "Festung Mark", _coords),
      Event("Wohnheim-Spieleabend", DateTime(2020, 7, 2, 20), null, "Campus Theater", _coords),
      Event("Grillen", DateTime(2020, 7, 6, 16), null, "vor Gebäude 16", _coords),
      Event("Immatrikulationsfeier", DateTime(2020, 8, 2, 19), DateTime(2020, 8, 2, 22), "Festung Mark", _coords),
      Event("Wohnheim-Spieleabend", DateTime(2020, 8, 5, 20), null, "Campus Theater", _coords),
      Event("Grillen", DateTime(2020, 8, 6, 16), DateTime(2020, 8, 6, 20), "vor Gebäude 16", _coords),
      Event("Immatrikulationsfeier", DateTime(2020, 8, 6, 20), null, "vor Gebäude 16", _coords),
      Event("Immatrikulationsfeier", DateTime(2020, 8, 7), null, "vor Gebäude 16", _coords),
      Event("Grillen", DateTime(2020, 8, 7), null, "vor Gebäude 16", _coords)
    ];
  }

  static Map<DateTime, List<Event>> getEventsGroupByDate() {
    List<Event> events = getEvents();
    Map<DateTime, List<Event>> map = Map();
    events.forEach((event) {
      DateTime date = DateTime(event.start.year, event.start.month, event.start.day);
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
      Event("Immatrikulationsfeier", DateTime(2020, 8, 2, 19), DateTime(2020, 8, 2, 22), "Festung Mark", _coords),
      Event("Wohnheim-Spieleabend", DateTime(2020, 8, 5, 20), null, "Campus Theater", null),
      Event("Grillen", DateTime(2020, 8, 6, 16), DateTime(2020, 8, 6, 20), "vor Gebäude 16", _coords)
    ];
  }
}