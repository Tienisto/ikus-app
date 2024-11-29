import 'package:html/parser.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/utility/extensions.dart';
import 'package:intl/intl.dart';

class MailMessage {

  static DateFormat _dateFormatter = DateFormat("dd.MM.yyyy");
  static DateFormat _timeFormatterDe = DateFormat("HH:mm");
  static DateFormat _timeFormatterEn = DateFormat("h:mm a");

  final int uid;
  final String from;
  final List<String> to;
  final List<String> cc;
  final DateTime timestamp;
  final String subject;
  final String? contentPlain;
  final String? contentHtml;

  MailMessage({required this.uid, required this.from, required this.to, required this.cc, required this.timestamp, required this.subject, required this.contentPlain, required this.contentHtml});

  String get formattedTimestamp {
    if (timestamp.isSameDay(DateTime.now())) {
      if (LocaleSettings.currentLocale == AppLocale.en)
        return _timeFormatterEn.format(timestamp);
      else
        return _timeFormatterDe.format(timestamp);
    } else {
      return _dateFormatter.format(timestamp);
    }
  }

  static MailMessage fromMap(Map<String, dynamic> map) {
    return MailMessage(
      uid: map['uid'],
      from: map['from'],
      to: map['toList']?.cast<String>() ?? [map['to']], // fallback
      cc: map['cc'].cast<String>(),
      timestamp: DateTime.parse(map['timestamp']).toLocal(),
      subject: map['subject'],
      contentPlain: map['contentPlain'],
      contentHtml: map['contentHtml'] ?? map['content'] // fallback to content for legacy reasons
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'from': from,
      'toList': to,
      'cc': cc,
      'timestamp': timestamp.toIso8601String(),
      'subject': subject,
      'contentPlain': contentPlain,
      'contentHtml': contentHtml
    };
  }

  String getPlainOrParseHtml() {
    if (contentPlain != null)
      return contentPlain!;

    // fallback to html parsing
    if (contentHtml != null) {
      final raw = contentHtml!.replaceAll('<br>', '\n');
      final document = parse(raw);
      return parse(document.body?.text ?? '').documentElement?.text ?? '';
    }

    return '';
  }

  @override
  String toString() {
    return subject;
  }
}