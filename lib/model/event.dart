import 'package:ikus_app/i18n/strings.g.dart';
import 'package:intl/intl.dart';
import "package:latlong/latlong.dart";

class Event {

  static final DateFormat _format = DateFormat('dd.MM.yyyy, kk:mm', LocaleSettings.currentLocale);
  static final DateFormat formatOnlyDate = DateFormat('dd.MM.yyyy', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyDateWithWeekday = DateFormat('EEE, dd.MM.yyyy', LocaleSettings.currentLocale);
  static final DateFormat _formatOnlyTime= DateFormat('kk:mm', LocaleSettings.currentLocale);

  final String name;
  final String info;
  final DateTime start;
  final DateTime end;
  final String place;
  final LatLng coords;

  const Event(this.name, this.info, this.start, this.end, this.place, this.coords);

  String get formattedTimestamp {
    if (hasTime)
      return _format.format(start);
    else
      return formatOnlyDate.format(start);
  }

  /// same as formattedTimestamp but only date
  String get formattedStartDate {
    return formatOnlyDate.format(start);
  }

  /// same as formattedDate but with weekday
  String get formattedStartDateWithWeekday {
    return _formatOnlyDateWithWeekday.format(start);
  }

  /// same as formattedTimestamp but only time
  String get formattedTime {
    if (hasEndTime)
      return _formatOnlyTime.format(start) + ' - ' + _formatOnlyTime.format(end);
    else
      return _formatOnlyTime.format(start);
  }

  bool get hasTime {
    return start.hour != 0 || start.minute != 0;
  }

  bool get hasEndTime {
    return end != null;
  }
}