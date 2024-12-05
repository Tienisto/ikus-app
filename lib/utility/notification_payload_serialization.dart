import 'package:collection/collection.dart';
import 'package:ikus_app/screens/event_screen.dart';
import 'package:ikus_app/screens/mail_screen.dart';
import 'package:ikus_app/service/calendar_service.dart';
import 'package:ikus_app/utility/globals.dart';

class NotificationPayloadSerialization {
  static final RegExp _regexMailScreen = RegExp(r'^screen:(\w+):?(\d+)*$');

  static String mailScreen(int? uid) {
    return uid == null ? 'screen:mail' : 'screen:mail:$uid';
  }

  static String event(int eventId) {
    return 'screen:event:$eventId';
  }

  static SimpleWidgetBuilder? parse(String payload) {
    final match = _regexMailScreen.firstMatch(payload);
    if (match == null) {
      return null;
    }

    switch (match.group(1)) {
      case 'mail':
        final String? uid = match.group(2);
        if (uid != null) {
          return () => MailScreen(openUid: int.parse(uid));
        } else {
          return () => MailScreen();
        }
      case 'event':
        final int? eventId = int.tryParse(match.group(2) ?? '');
        if (eventId == null) {
          return null;
        }

        final event = CalendarService.instance.getMyEvents().firstWhereOrNull((event) => event.id == eventId);
        if (event == null) {
          return null;
        }

        return () => EventScreen(event);
      default:
        return null;
    }
  }
}
