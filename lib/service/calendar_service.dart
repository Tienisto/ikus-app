import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/local/data_with_timestamp.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/event.dart';
import 'package:ikus_app/model/local/event_registration_data.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/notification_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/channel_handler.dart';
import 'package:intl/intl.dart';

class CalendarService implements SyncableService {

  static final CalendarService _instance = CalendarService();
  static CalendarService get instance => _instance;

  late DateTime _lastUpdate;
  late ChannelHandler<Event> _channelHandler;
  late List<Event> _events;
  late List<Event> _myEvents;
  late EventRegistrationData _eventRegistrationData;

  @override
  String id = 'CALENDAR';

  @override
  String getDescription() => t.sync.items.calendar;

  @override
  Future<void> sync({required bool useNetwork, String? useJSON, bool showNotifications = false, AddFutureCallback? onBatchFinished}) async {
    DataWithTimestamp data = await ApiService.getCacheOrFetchString(
      route: 'calendar',
      locale: LocaleSettings.currentLocale.languageTag,
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

    // show notifications
    final notifiedEventIds = SettingsService.instance.getMyEventsNotified2h();
    final notifyingEvent = myEvents.firstWhereOrNull((event) => event.startTime.isBefore(now.add(Duration(hours: 2))) && !notifiedEventIds.contains(event.id));
    if (showNotifications && notifyingEvent != null) {
      final showNotification = () => NotificationService.createInstance().showEventReminder(
        eventId: notifyingEvent.id,
        title: notifyingEvent.name,
        description: DateFormat('HH:mm').format(notifyingEvent.startTime),
      );

      if (onBatchFinished != null) {
        // show at the end of batch update
        onBatchFinished(showNotification);
      } else {
        // show immediately
        showNotification();
      }

      notifiedEventIds.add(notifyingEvent.id);
      SettingsService.instance.setMyEventsNotified2h(notifiedEventIds);
    }

    _channelHandler = ChannelHandler(channels, subscribedChannels);
    _events = events;
    _myEvents = myEvents;
    _eventRegistrationData = await PersistentService.instance.getEventRegistrationData();
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

  EventRegistrationData getEventRegistrationData() {
    return _eventRegistrationData;
  }

  Future<void> saveEventRegistrationToken(int eventId, String token) async {
    final newInstance = _eventRegistrationData.copyWithNewTokens({
      ..._eventRegistrationData.registrationTokens,
      eventId: token
    });
    _eventRegistrationData = newInstance;
    await PersistentService.instance.setEventRegistrationData(newInstance);
  }

  Future<void> deleteEventRegistrationToken(int eventId) async {
    final newInstance = _eventRegistrationData.copyWithNewTokens(Map.from(_eventRegistrationData.registrationTokens)..remove(eventId));
    _eventRegistrationData = newInstance;
    await PersistentService.instance.setEventRegistrationData(newInstance);
  }

  Future<void> saveEventRegistrationAutofill({required int? matriculationNumber, required String? firstName, required String? lastName, required String? email, required String? address, required String? country}) async {
    final newInstance = EventRegistrationData(
        matriculationNumber: matriculationNumber,
        firstName: firstName,
        lastName: lastName,
        email: email,
        address: address,
        country: country,
        registrationTokens: _eventRegistrationData.registrationTokens
    );
    _eventRegistrationData = newInstance;
    await PersistentService.instance.setEventRegistrationData(newInstance);
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