
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/mail_message.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/notification_payload_serialization.dart';
import 'package:ikus_app/utility/ui.dart';

/// shows notification
class NotificationService {

  FlutterLocalNotificationsPlugin _plugin;
  NotificationService._(this._plugin);

  static NotificationService createInstance() {

    final settings = InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
        iOS: IOSInitializationSettings()
    );

    final notificationPlugin = FlutterLocalNotificationsPlugin()
      ..initialize(settings, onSelectNotification: onSelectNotification);
    return NotificationService._(notificationPlugin);
  }

  static Future<void> requestIOSPermissions() async {
    await IOSFlutterLocalNotificationsPlugin()
        .requestPermissions(sound: true, alert: true, badge: true);
  }

  Future<void> showTest() async {
    final platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          'test',
          'Test',
          'Showing Test Notification',
          importance: Importance.max,
          priority: Priority.high,
          color: OvguColor.primary
        ),
        iOS: IOSNotificationDetails()
    );

    await _plugin.show(0, 'Test',
        'Showing Test Notification',
        platformChannelSpecifics, payload: 'Test'
    );
  }

  Future<void> showNewMail(List<MailMessage> mails) async {
    final platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
            'newMail',
            'New Mail',
            'New Mail',
            importance: Importance.max,
            priority: Priority.high,
            color: OvguColor.primary
        ),
        iOS: IOSNotificationDetails()
    );

    final id = DateTime.now().millisecondsSinceEpoch;
    if (mails.length == 1) {
      final mail = mails.first;
      final info = mail.subject;
      final payload = NotificationPayloadSerialization.mailScreen(mail.uid);
      await _plugin.show(id, t.notifications.newMail.titleOne,
          info.substring(0, min(info.length, 100)),
          platformChannelSpecifics, payload: payload
      );
    } else {
      final info = mails.map((m) => m.subject).join(', ');
      final payload = NotificationPayloadSerialization.mailScreen(null);
      await _plugin.show(id, t.notifications.newMail.titleMultiple(count: mails.length),
          info.substring(0, min(info.length, 100)),
          platformChannelSpecifics, payload: payload
      );
    }
  }

  static Future<void> onSelectNotification(String payload) async {
    print('Received notification callback');
    SimpleWidgetBuilder screen = NotificationPayloadSerialization.parse(payload);
    if (screen != null) {
      final context = MainScreen.mainScreenKey.currentState.context;
      pushScreen(context, screen);
    }
  }
}