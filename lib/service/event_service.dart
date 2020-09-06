import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/utility/channel_handler.dart';
import "package:latlong/latlong.dart";

class EventService {

  static Channel _allgemein = Channel(id: 1, name: "Allgemein");
  static Channel _wohnheim = Channel(id: 2, name: "Wohnheim");
  static ChannelHandler<Event> _channelHandler = ChannelHandler([_allgemein, _wohnheim], [_allgemein, _wohnheim]);

  static LatLng _coords = LatLng(52.137813, 11.646508);
  static String _info = "Zum Willkommenstag an der Otto-von-Guericke-Universität Magdeburg erwartet Studienanfängerinnen und Studienanfänger jährlich ein umfangreiches Programm auf dem Campus.";

  static List<Event> _events = [
    Event("Immatrikulationsfeier", _info, _allgemein, DateTime(2020, 9, 2, 19), null, "Festung Mark", _coords),
    Event("Wohnheim-Spieleabend", _info, _wohnheim, DateTime(2020, 9, 2, 20), null, "Campus Theater", _coords),
    Event("Grillen", _info, _allgemein, DateTime(2020, 9, 6, 16), null, "vor Gebäude 16", _coords),
    Event("Immatrikulationsfeier", _info, _allgemein, DateTime(2020, 9, 7, 19), DateTime(2020, 9, 7, 22), "Festung Mark", _coords),
    Event("Wohnheim-Spieleabend", _info, _wohnheim, DateTime(2020, 9, 8, 20), null, "Campus Theater", _coords),
    Event("Grillen", _info, _allgemein, DateTime(2020, 9, 8, 16), DateTime(2020, 9, 8, 20), "vor Gebäude 16", _coords),
    Event("Immatrikulationsfeier", _info, _allgemein, DateTime(2020, 9, 10, 20), null, "vor Gebäude 16", _coords),
    Event("Immatrikulationsfeier", _info, _allgemein, DateTime(2020, 9, 10), null, "vor Gebäude 16", _coords),
    Event("Grillen", _info, _allgemein, DateTime(2020, 9, 11), null, "vor Gebäude 16", _coords)
  ];

  static List<Event> getEvents() {
    return _channelHandler.filter(_events, (item) => item.channel.id);
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
    DateTime now = DateTime.now();
    List<Event> events = getEvents();
    List<Event> nextEvents = [];
    for (int i = 0; i < events.length; i++) {
      if (events[i].start.isAfter(now)) {
        nextEvents.add(events[i]);
        if(nextEvents.length == 3)
          break;
      }
    }
    return nextEvents;
  }

  static List<Channel> getChannels() {
    return _channelHandler.getAvailable();
  }

  static List<Channel> getSubscribed() {
    return _channelHandler.getSubscribed();
  }

  static Future<void> subscribe(Channel channel) async {
    await _channelHandler.subscribe(channel);
  }

  static Future<void> unsubscribe(Channel channel) async {
    await _channelHandler.unsubscribe(channel);
  }
}