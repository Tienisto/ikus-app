import 'package:intl/intl.dart';

class Event {

  static final DateFormat _format = DateFormat('dd.MM.yyyy, kk:mm');
  static final DateFormat _formatOnlyDate = DateFormat('dd.MM.yyyy');
  static final DateFormat _formatOnlyTime= DateFormat('kk:mm');

  final String name;
  final DateTime timestamp;
  final String place;

  const Event(this.name, this.timestamp, this.place);

  String getFormattedTimestamp() {
    if (hasTime())
      return _format.format(timestamp);
    else
      return _formatOnlyDate.format(timestamp);
  }

  /// same as getFormattedTimestamp but only date
  String getFormattedDate() {
    return _formatOnlyDate.format(timestamp);
  }

  /// same as getFormattedTimestamp but only time
  String getFormattedTime() {
    return _formatOnlyTime.format(timestamp);
  }

  bool hasTime() {
    return timestamp.hour != 0 || timestamp.minute != 0;
  }
}