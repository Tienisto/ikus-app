import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/model/mail/mail_message.dart';
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
      iOS: DarwinInitializationSettings(),
    );

    final notificationPlugin = FlutterLocalNotificationsPlugin()
      ..initialize(
        settings,
        onDidReceiveNotificationResponse: onSelectNotification,
      );
    return NotificationService._(notificationPlugin);
  }

  static Future<void> requestIOSPermissions() async {
    await IOSFlutterLocalNotificationsPlugin().requestPermissions(sound: true, alert: true, badge: true);
  }

  Future<void> showTest() async {
    final platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'test',
        'Test',
        importance: Importance.max,
        priority: Priority.high,
        color: OvguColor.primary,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(0, 'Test', 'Showing Test Notification', platformChannelSpecifics, payload: 'Test');
  }

  Future<void> showNewMail(List<MailMessage> mails) async {
    final platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'newMail',
        'New Mail',
        importance: Importance.max,
        priority: Priority.high,
        color: OvguColor.primary,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final id = _getRandomId();
    final title = t.notifications.newMail.title(n: mails.length);
    final String info;
    final String payload;
    if (mails.length == 1) {
      final mail = mails.first;
      info = mail.subject;
      payload = NotificationPayloadSerialization.mailScreen(mail.uid);
    } else {
      info = mails.map((m) => m.subject).join(', ');
      payload = NotificationPayloadSerialization.mailScreen(null);
    }

    await _plugin.show(
      id,
      title,
      info.substring(0, min(info.length, 100)),
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showEventReminder({
    required int eventId,
    required String title,
    required String description,
  }) async {
    final platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'eventReminder',
        'Event Reminder',
        importance: Importance.max,
        priority: Priority.high,
        color: OvguColor.primary,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final id = _getRandomId();
    await _plugin.show(
      id,
      title,
      description.substring(0, min(description.length, 100)),
      platformChannelSpecifics,
      payload: NotificationPayloadSerialization.event(eventId),
    );
  }

  static Future<void> onSelectNotification(NotificationResponse response) async {
    print('Received notification callback');
    final payload = response.payload;
    if (payload == null) return;

    SimpleWidgetBuilder? screen = NotificationPayloadSerialization.parse(payload);
    if (screen != null) {
      final context = MainScreen.mainScreenKey.currentState?.context;
      if (context != null) pushScreen(context, screen);
    }
  }

  static int _getRandomId() {
    return Random().nextInt(1000000);
  }
}
