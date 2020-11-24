
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ikus_app/utility/ui.dart';

/// shows notification
class NotificationService {

  FlutterLocalNotificationsPlugin _plugin;
  NotificationService._(this._plugin);

  static NotificationService createInstance() {
    final notificationPlugin = new FlutterLocalNotificationsPlugin();

    final settings = InitializationSettings(
        android: AndroidInitializationSettings('@drawable/ic_notification'),
        iOS: IOSInitializationSettings()
    );

    notificationPlugin.initialize(settings);
    return NotificationService._(notificationPlugin);
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
}