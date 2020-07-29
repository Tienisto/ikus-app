import 'package:flutter/material.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/ui.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: IconText(
              size: OvguPixels.headerSize,
              distance: OvguPixels.headerDistance,
              icon: Icons.settings,
              text: t.main.settings.title,
            ),
          ),
        ],
      ),
    );
  }
}
