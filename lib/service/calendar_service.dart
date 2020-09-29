import 'dart:convert';

import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/api_data.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/channel_handler.dart';

class CalendarService implements SyncableService {

  static final CalendarService _instance = CalendarService();
  static CalendarService get instance => _instance;

  DateTime _lastUpdate;
  ChannelHandler<Event> _channelHandler;
  List<Event> _events;

  @override
  String getName() => t.main.settings.syncItems.calendar;

  @override
  Future<void> sync({bool useCacheOnly}) async {
    ApiData data = await ApiService.getCacheOrFetchString(
      route: 'calendar',
      locale: LocaleSettings.currentLocale,
      useCache: useCacheOnly,
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

    List<int> subscribedIds = SettingsService.instance.getCalendarChannels();
    List<Channel> subscribedChannels = subscribedIds != null ? channels.where((channel) => subscribedIds.any((id) => channel.id == id)).toList() : [...channels];

    _channelHandler = ChannelHandler(channels, subscribedChannels);
    _events = events;
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration getMaxAge() => Duration(hours: 1);

  List<Event> getEvents() {
    return _channelHandler.onlySubscribed(_events, (item) => item.channel.id);
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

  void subscribe(Channel channel) {
    _channelHandler.subscribe(channel);
    _updateChannelSettings();
  }

  void unsubscribe(Channel channel) {
    _channelHandler.unsubscribe(channel);
    _updateChannelSettings();
  }

  void _updateChannelSettings() {
    List<int> subscribed = _channelHandler.getSubscribed().map((channel) => channel.id).toList();
    SettingsService.instance.setCalendarChannels(subscribed);
  }
}