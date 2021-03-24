import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/channel_handler.dart';

class CalendarService implements SyncableService {

  static final CalendarService _instance = CalendarService();
  static CalendarService get instance => _instance;

  late DateTime _lastUpdate;
  late ChannelHandler<Event> _channelHandler;
  late List<Event> _events;
  late List<Event> _myEvents;

  @override
  String id = 'CALENDAR';

  @override
  String getDescription() => t.sync.items.calendar;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'calendar',
      locale: LocaleSettings.currentLocale,
      useJSON: useJSON,
      useNetwork: useNetwork,
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

    List<int>? subscribedIds = SettingsService.instance.getCalendarChannels();
    List<Channel> subscribedChannels = subscribedIds != null ? channels.where((channel) => subscribedIds.any((id) => channel.id == id)).toList() : [...channels];

    // my next events
    DateTime now = DateTime.now();
    List<int> myEventIds = SettingsService.instance.getMyEvents();
    List<Event> myEvents = myEventIds
        .map((id) => events.firstWhereOrNull((event) => event.id == id))
        .where((event) => event != null && isInFuture(event, now))
        .cast<Event>()
        .toList();

    _channelHandler = ChannelHandler(channels, subscribedChannels);
    _events = events;
    _myEvents = myEvents;
    _lastUpdate = data.timestamp;
  }

  @override
  DateTime getLastUpdate() {
    return _lastUpdate;
  }

  @override
  Duration maxAge = Duration(hours: 1);

  @override
  String batchKey = 'CALENDAR';

  List<Event> getEvents() {
    return _channelHandler.onlySubscribed(_events, (item) => item.channel.id);
  }

  Map<DateTime, List<Event>> getEventsGroupByDate() {
    return getEvents().groupByDate();
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

  List<Event> getMyEvents() {
    return _myEvents;
  }

  Map<DateTime, List<Event>> getMyEventsGrouped() {
    return _myEvents.groupByDate();
  }

  List<Event> getMyNextEvents() {
    int end = _myEvents.length >= 3 ? 3 : _myEvents.length;
    return _myEvents.sublist(0, end);
  }

  bool isMyEvent(Event event) {
    return _myEvents.any((e) => e.id == event.id);
  }

  void toggleMyEvent(Event event) {
    if (isMyEvent(event))
      removeEvent(event);
    else
      addEvent(event);
  }

  void addEvent(Event event) {

    if (event.startTime.isBefore(DateTime.now()) || _myEvents.any((e) => e.id == event.id))
      return;

    _myEvents = [..._myEvents, event]..sort((a, b) => a.startTime.compareTo(b.startTime));
    _updateMyEventsSettings();
  }

  void removeEvent(Event event) {
    _myEvents = _myEvents.where((e) => e.id != event.id).toList();
    _updateMyEventsSettings();
  }

  void _updateMyEventsSettings() {
    List<int> myEvents = _myEvents.map((e) => e.id).toList();
    SettingsService.instance.setMyEvents(myEvents);
  }

  bool isInFuture(Event event, [DateTime? now]) {
    if (now == null) {
      now = DateTime.now();
    }

    return event.startTime.isAfter(now) || (event.endTime != null && event.endTime!.isAfter(now));
  }
}