import 'dart:convert';

import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/channel_handler.dart';

class EventService implements SyncableService {

  static final EventService _instance = EventService();
  static EventService get instance => _instance;

  DateTime _lastUpdate;
  ChannelHandler<Event> _channelHandler;
  List<Event> _events;

  @override
  String getName() => t.main.settings.syncItems.calendar;

  @override
  Future<void> sync({bool useCache}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'calendar',
      locale: LocaleSettings.currentLocale,
      useCache: useCache,
      fallback: {
        'channels': [],
        'events': []
      }
    );

    Map<String, dynamic> map = jsonDecode(data.data);
    List<dynamic> channelsRaw = map['channels'];
    List<Channel> channels = channelsRaw.map((c) => Channel.fromMap(c)).toList();

    List<dynamic> eventsRaw = map['events'];
    List<Event> events = eventsRaw.map((e) => Event.fromMap(e)).toList();

    _channelHandler = ChannelHandler(channels, [...channels]);
    _events = events;
    _lastUpdate = data.timestamp;
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