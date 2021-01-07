import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:intl/intl.dart';
import "package:latlong/latlong.dart";

class Event {

  static final DateFormat _formatOnlyDate = DateFormat('dd.MM.yyyy', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyDateWithWeekday = DateFormat('EEE, dd.MM.yyyy', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyTimeDe = DateFormat('HH:mm', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyTimeEn = DateFormat('h:mm a', LocaleSettings.currentLocale);

  final int id;
  final String name;
  final String info;
  final Channel channel;
  final DateTime startTime;
  final DateTime endTime;
  final String place;
  final LatLng coords;

  const Event({this.id, this.name, this.info, this.channel, this.startTime, this.endTime, this.place, this.coords});

  /// same as formattedTimestamp but only time
  String get formattedSameDayTime {
    if (hasEndTimestamp)
      return formatTime(startTime) + ' - ' + formatTime(endTime);
    else
      return formatTime(startTime);
  }

  bool get hasEndTimestamp {
    return endTime != null;
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
        coords: map['coords'] != null ? LatLng(map['coords']['x'], map['coords']['y']) : null
    );
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
    if (LocaleSettings.currentLocale == 'en')
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
      List<Event> currEvents = map[date];
      if (currEvents != null) {
        currEvents.add(event);
      } else {
        map[date] = [event];
      }
    });

    return map;
  }
}