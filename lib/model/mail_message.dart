import 'package:intl/intl.dart';

class MailMessage {

  static DateFormat _dateFormatter = DateFormat("dd.MM.yyyy");

  final int uid;
  final String from;
  final DateTime timestamp;
  final String subject;
  final String preview;
  final String content;

  MailMessage({this.uid, this.from, this.timestamp, this.subject, this.preview, this.content});

  String get formattedTimestamp {
    return _dateFormatter.format(timestamp);
  }

  static MailMessage fromMap(Map<String, dynamic> map) {
    return MailMessage(
      uid: map['uid'],
      from: map['from'],
      timestamp: DateTime.parse(map['timestamp']).toLocal(),
      subject: map['subject'],
      preview: map['preview'],
      content: map['content']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'from': from,
      'timestamp': timestamp.toIso8601String(),
      'subject': subject,
      'preview': preview,
      'content': content
    };
  }

  @override
  String toString() {
    return subject;
  }
}