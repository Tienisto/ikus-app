import 'package:intl/intl.dart';

class MailMessage {

  static DateFormat _dateFormatter = DateFormat("dd.MM.yyyy");

  final String from;
  final DateTime timestamp;
  final String subject;
  final String preview;
  final String content;

  MailMessage({this.from, this.timestamp, this.subject, this.preview, this.content});

  String get formattedTimestamp {
    return _dateFormatter.format(timestamp);
  }

  @override
  String toString() {
    return subject;
  }
}