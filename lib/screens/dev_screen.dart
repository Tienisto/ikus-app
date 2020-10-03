import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/ovgu_switch.dart';
import 'package:ikus_app/components/settings_item.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class DevScreen extends StatefulWidget {

  @override
  _DevScreenState createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
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
          SizedBox(height: 20),
          SettingsItem(
              left: 'Show Tutorial',
              right: OvguButton(
                type: OvguButtonType.ICON_WIDE,
                callback: () {
                  setScreen(context, () => MainScreen(tutorial: true));
                },
                child: Icon(Icons.restore, color: Colors.white),
              )
          )
        ],
      ),
    );
  }
}
