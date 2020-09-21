import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/channel.dart';
import 'package:intl/intl.dart';
import "package:latlong/latlong.dart";

class Event {

  static final DateFormat _format = DateFormat('dd.MM.yyyy, HH:mm', LocaleSettings.currentLocale);
  static final DateFormat formatOnlyDate = DateFormat('dd.MM.yyyy', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyDateWithWeekday = DateFormat('EEE, dd.MM.yyyy', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyTime= DateFormat('kk:mm', LocaleSettings.currentLocale);

  final int id;
  final String name;
  final String info;
  final Channel channel;
  final DateTime startTime;
  final DateTime endTime;
  final String place;
  final LatLng coords;

  const Event({this.id, this.name, this.info, this.channel, this.startTime, this.endTime, this.place, this.coords});

  String get formattedTimestamp {
    if (hasTime)
      return _format.format(startTime);
    else
      return formatOnlyDate.format(startTime);
  }

  /// same as formattedTimestamp but only date
  String get formattedStartDate {
    return formatOnlyDate.format(startTime);
  }

  /// same as formattedDate but with weekday
  String get formattedStartDateWithWeekday {
    return _formatOnlyDateWithWeekday.format(startTime);
  }

  /// same as formattedTimestamp but only time
  String get formattedTime {
    if (hasEndTime)
      return _formatOnlyTime.format(startTime) + ' - ' + _formatOnlyTime.format(endTime);
    else
      return _formatOnlyTime.format(startTime);
  }

  bool get hasTime {
    return startTime.hour != 0 || startTime.minute != 0;
  }

  bool get hasEndTime {
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
}