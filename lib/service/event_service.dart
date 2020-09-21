import 'dart:convert';

import 'package:http/http.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/channel_handler.dart';
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
      Event(name: "Immatrikulationsfeier", info: _info, channel: _allgemein, startTime: DateTime(2020, 10, 2, 19), endTime: null, place: "Festung Mark", coords: _coords),
      Event(name: "Wohnheim-Spieleabend", info: _info, channel: _wohnheim, startTime: DateTime(2020, 10, 2, 20), endTime: null, place: "Campus Theater", coords: _coords),
      Event(name: "Grillen", info: _info, channel: _allgemein, startTime: DateTime(2020, 10, 6, 16), endTime: null, place: "vor Gebäude 16", coords: _coords),
      Event(name: "Immatrikulationsfeier", info: _info, channel: _allgemein, startTime: DateTime(2020, 10, 7, 19), endTime: DateTime(2020, 9, 7, 22), place: "Festung Mark", coords: _coords),
      Event(name: "Wohnheim-Spieleabend", info: _info, channel: _wohnheim, startTime: DateTime(2020, 10, 8, 20), endTime: null, place: "Campus Theater", coords: _coords),
      Event(name: "Grillen", info: _info, channel: _allgemein, startTime: DateTime(2020, 10, 8, 16), endTime: DateTime(2020, 10, 8, 20), place: "vor Gebäude 16", coords: _coords),
      Event(name: "Immatrikulationsfeier", info: _info, channel: _allgemein, startTime: DateTime(2020, 10, 10, 20), endTime: null, place: "vor Gebäude 16", coords: _coords),
      Event(name: "Immatrikulationsfeier", info: _info, channel: _allgemein, startTime: DateTime(2020, 10, 10), endTime: null, place: "vor Gebäude 16", coords: _coords),
      Event(name: "Grillen", info: _info, channel: _allgemein, startTime: DateTime(2020, 10, 11), endTime: null, place: "vor Gebäude 16", coords: _coords)
    ];

    service._lastUpdate = DateTime(2020, 8, 24, 13, 12);
    return service;
  }

  @override
  String getName() => t.main.settings.syncItems.calendar;

  @override
  Future<void> sync() async {
    Response response = await ApiService.getCacheOrFetch('calendar', LocaleSettings.currentLocale);
    Map<String, dynamic> map = jsonDecode(response.body);
    List<dynamic> channelsRaw = map['channels'];
    List<Channel> channels = channelsRaw.map((c) => Channel.fromMap(c)).toList();

    List<dynamic> eventsRaw = map['events'];
    List<Event> events = eventsRaw.map((e) => Event.fromMap(e)).toList();

    _channelHandler = ChannelHandler(channels, [...channels]);
    _events = events;
    _lastUpdate = DateTime.now();
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
      DateTime date = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
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
      if (events[i].startTime.isAfter(now)) {
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