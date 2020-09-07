import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/channel_handler.dart';
import 'package:ikus_app/utility/globals.dart';
import "package:latlong/latlong.dart";

class EventService implements SyncableService {

  static final EventService _instance = _init();
  static EventService get instance => _instance;

  DateTime _lastUpdate;
  ChannelHandler<Event> _channelHandler;
  List<Event> _events;

  static EventService _init() {
    EventService service = EventService();

    Channel _allgemein = Channel(id: 1, name: "Allgemein");
    Channel _wohnheim = Channel(id: 2, name: "Wohnheim");
    service._channelHandler = ChannelHandler([_allgemein, _wohnheim], [_allgemein, _wohnheim]);

    LatLng _coords = LatLng(52.137813, 11.646508);
    String _info = "Zum Willkommenstag an der Otto-von-Guericke-Universität Magdeburg erwartet Studienanfängerinnen und Studienanfänger jährlich ein umfangreiches Programm auf dem Campus.";
    service._events = [
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

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.calendar;

  @override
  Future<void> sync() async {
    await sleep(500);
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  List<Event> getEvents() {
    return _channelHandler.filter(_events, (item) => item.channel.id);
  }

  Map<DateTime, List<Event>> getEventsGroupByDate() {
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

  List<Event> getNextEvents() {
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

  List<Channel> getChannels() {
    return _channelHandler.getAvailable();
  }

  List<Channel> getSubscribed() {
    return _channelHandler.getSubscribed();
  }

  Future<void> subscribe(Channel channel) async {
    await _channelHandler.subscribe(channel);
  }

  Future<void> unsubscribe(Channel channel) async {
    await _channelHandler.unsubscribe(channel);
  }
}