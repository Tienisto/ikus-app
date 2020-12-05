import 'package:ikus_app/screens/mail_screen.dart';
import 'package:ikus_app/utility/globals.dart';

class NotificationPayloadSerialization {

  static RegExp _regexMailScreen = RegExp(r'^screen:mail:?(\d+)*$');
  static String mailScreen(int uid) => uid == null ? 'screen:mail' : 'screen:mail:$uid';

  static SimpleWidgetBuilder parse(String payload) {

    // mail screen
    RegExpMatch match = _regexMailScreen.firstMatch(payload);
    if (match != null) {
      final String uid = match.group(1);
      if (uid != null)
        return () => MailScreen(openUid: int.parse(uid));
      else
        return () => MailScreen();
    }

    return null;
  }
}