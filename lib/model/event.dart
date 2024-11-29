import 'package:collection/collection.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/model/coords.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:intl/intl.dart';

enum RegistrationField { MATRICULATION_NUMBER, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS, COUNTRY }

class Event {
  static final DateFormat _formatOnlyDate = DateFormat('dd.MM.yyyy', LocaleSettings.currentLocale.languageTag);
  static final DateFormat _formatOnlyDateWithWeekday = DateFormat('EEE, dd.MM.yyyy', LocaleSettings.currentLocale.languageTag);
  static final DateFormat _formatOnlyTimeDe = DateFormat('HH:mm', LocaleSettings.currentLocale.languageTag);
  static final DateFormat _formatOnlyTimeEn = DateFormat('h:mm a', LocaleSettings.currentLocale.languageTag);

  final int id;
  final String name;
  final String? info;
  final Channel channel;
  final DateTime startTime;
  final DateTime? endTime;
  final String? place;
  final Coords? coords;
  final List<RegistrationField> registrationFields;
  final int registrationSlots;
  final int registrationSlotsWaiting;
  final bool registrationOpen;
  final List<String> registrations;

  const Event({
    required this.id,
    required this.name,
    required this.info,
    required this.channel,
    required this.startTime,
    required this.endTime,
    required this.place,
    required this.coords,
    required this.registrationFields,
    required this.registrationSlots,
    required this.registrationSlotsWaiting,
    required this.registrationOpen,
    required this.registrations,
  });

  /// same as formattedTimestamp but only time
  String get formattedSameDayTime {
    if (endTime != null)
      return formatTime(startTime) + ' - ' + formatTime(endTime!);
    else
      return formatTime(startTime);
  }

  static Event fromMap(Map<String, dynamic> map) {
    return Event(
        id: map['id'],
        channel: Channel.fromMap(map['channel']),
        name: map['name'],
        info: map['info'],
        startTime: DateTime.parse(map['startTime']).toLocal(),
        endTime: map['endTime'] != null ? DateTime.parse(map['endTime']).toLocal() : null,
        place: map['place'],
        coords: map['coords'] != null ? Coords.fromMap(map['coords']) : null,
        registrationFields: ((map['registrationFields'] ?? []) as List)
            .map((f) => (f as String).toRegistrationField())
            .where((f) => f != null)
            .cast<RegistrationField>()
            .toList(),
        registrationSlots: map['registrationSlots'] ?? 0,
        registrationSlotsWaiting: map['registrationSlotsWaiting'] ?? 0,
        registrationOpen: map['registrationOpen'] ?? false,
        registrations: (map['registrations'] ?? []).cast<String>());
  }

  @override
  String toString() {
    return '$name ($startTime)';
  }

  static String formatDate(DateTime timestamp, {bool weekday = false}) {
    if (weekday)
      return _formatOnlyDateWithWeekday.format(timestamp);
    else
      return _formatOnlyDate.format(timestamp);
  }

  static String formatTime(DateTime time) {
    if (LocaleSettings.currentLocale == AppLocale.en)
      return _formatOnlyTimeEn.format(time);
    else
      return _formatOnlyTimeDe.format(time);
  }

  static String formatFull(DateTime time, {bool weekday = false}) {
    String result = formatDate(time, weekday: weekday);
    if (!time.hasTime()) {
      return result;
    }

    // append time
    return result + ', ' + formatTime(time);
  }
}

extension EventGroup on List<Event> {
  Map<DateTime, List<Event>> groupByDate() {
    Map<DateTime, List<Event>> map = Map();
    this.forEach((event) {
      DateTime date = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      List<Event>? currEvents = map[date];
      if (currEvents != null) {
        currEvents.add(event);
      } else {
        map[date] = [event];
      }
    });

    return map;
  }
}

extension on String {
  RegistrationField? toRegistrationField() {
    return RegistrationField.values.firstWhereOrNull((element) => this == element.name);
  }
}
