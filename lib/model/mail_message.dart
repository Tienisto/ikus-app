import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MailMessage {

  static DateFormat _dateFormatter = DateFormat("dd.MM.yyyy");

  final int uid;
  final String from;
  final String to;
  final List<String> cc;
  final DateTime timestamp;
  final String subject;
  final String preview;
  final String content;

  MailMessage({@required this.uid, @required this.from, @required this.to, @required this.cc, @required this.timestamp, @required this.subject, @required this.preview, @required this.content});

  String get formattedTimestamp {
    return _dateFormatter.format(timestamp);
  }

  static MailMessage fromMap(Map<String, dynamic> map) {
    return MailMessage(
      uid: map['uid'],
      from: map['from'],
      to: map['to'],
      cc: map['cc'].cast<String>(),
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
      'to': to,
      'cc': cc,
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