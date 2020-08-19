import 'package:ikus_app/i18n/strings.g.dart';
import 'package:intl/intl.dart';
import "package:latlong/latlong.dart";

class Event {

  static final DateFormat _format = DateFormat('dd.MM.yyyy, kk:mm', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyDate = DateFormat('dd.MM.yyyy', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyDateWithWeekday = DateFormat('EEEE, dd.MM.yyyy', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyTime= DateFormat('kk:mm', LocaleSettings.currentLocale);

  final String name;
  final DateTime timestamp;
  final String place;
  final LatLng coords;

  const Event(this.name, this.timestamp, this.place, this.coords);

  String get formattedTimestamp {
    if (hasTime)
      return _format.format(timestamp);
    else
      return _formatOnlyDate.format(timestamp);
  }

  /// same as formattedTimestamp but only date
  String get formattedDate {
    return _formatOnlyDate.format(timestamp);
  }

  /// same as formattedDate but with weekday
  String get formattedDateWithWeekday {
    return _formatOnlyDateWithWeekday.format(timestamp);
  }

  /// same as formattedTimestamp but only time
  String get formattedTime {
    return _formatOnlyTime.format(timestamp);
  }

  bool get hasTime {
    return timestamp.hour != 0 || timestamp.minute != 0;
  }
}