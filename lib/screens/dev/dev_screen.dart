import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/ovgu_switch.dart';
import 'package:ikus_app/components/settings_item.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/screens/dev/background_task_log_screen.dart';
import 'package:ikus_app/screens/dev/log_error_screen.dart';
import 'package:ikus_app/screens/dev/notified_events_screen.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/service/mail_service.dart';
import 'package:ikus_app/service/notification_service.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/globals.dart';

class DevScreen extends StatefulWidget {

  @override
  _DevScreenState createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {

  static const double SPACE_BETWEEN = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.dev.title)
      ),
      body: MainListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          SettingsItem(
            left: 'Server',
            right: OvguSwitch(
              state: SettingsService.instance.getDevServer() ? SwitchState.LEFT : SwitchState.RIGHT,
              left: 'DEV',
              right: 'LIVE',
              callback: (state) {
                setState(() {
                  SettingsService.instance.setDevServer(state == SwitchState.LEFT);
                });
              }
            ),
          ),
          SizedBox(height: SPACE_BETWEEN),
          SettingsItem(
              left: 'Error log',
              right: OvguButton(
                callback: () {
                  pushScreen(context, () => LogErrorScreen());
                },
                child: Icon(Icons.bug_report, color: Colors.white),
              )
          ),
          SizedBox(height: SPACE_BETWEEN),
          SettingsItem(
              left: 'Background task log',
              right: OvguButton(
                callback: () {
                  pushScreen(context, () => BackgroundTaskLogScreen());
                },
                child: Icon(Icons.schedule, color: Colors.white),
              )
          ),
          SizedBox(height: SPACE_BETWEEN),
          SettingsItem(
              left: 'Notified events',
              right: OvguButton(
                callback: () {
                  pushScreen(context, () => NotifiedEventsScreen());
                },
                child: Icon(Icons.schedule, color: Colors.white),
              )
          ),
          SizedBox(height: SPACE_BETWEEN),
          SettingsItem(
              left: 'Start tutorial',
              right: OvguButton(
                callback: () {
                  setScreen(context, () => MainScreen(tutorial: true));
                },
                child: Icon(Icons.help, color: Colors.white),
              )
          ),
          SizedBox(height: SPACE_BETWEEN),
          SettingsItem(
              left: 'Show notification',
              right: OvguButton(
                callback: () {
                  NotificationService.createInstance().showTest();
                },
                child: Icon(Icons.notifications, color: Colors.white),
              )
          ),
          SizedBox(height: SPACE_BETWEEN),
          SettingsItem(
              left: 'Delete API cache',
              right: OvguButton(
                callback: () async {
                  await PersistentService.instance.deleteApiCache();
                },
                child: Icon(Icons.delete, color: Colors.white),
              )
          ),
          SizedBox(height: SPACE_BETWEEN),
          SettingsItem(
              left: 'Delete mail cache',
              right: OvguButton(
                callback: () async {
                  await MailService.instance.deleteCache();
                },
                child: Icon(Icons.delete, color: Colors.white),
              )
          ),
          SizedBox(height: SPACE_BETWEEN),
          SettingsItem(
              left: 'Disable dev settings',
              right: OvguButton(
                callback: () {
                  SettingsService.instance.setDevSettings(false);
                  SettingsService.instance.setDevServer(false);
                  Navigator.pop(context);
                },
                child: Icon(Icons.visibility_off, color: Colors.white),
              )
          )
        ],
      ),
    );
  }
}
