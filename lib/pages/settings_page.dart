import 'package:flutter/material.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/globals.dart';
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
        physics: Adaptive.getScrollPhysics(),
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
          SizedBox(height: 20),
          Padding(
            padding: OvguPixels.mainScreenPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(t.main.settings.language, style: TextStyle(fontSize: 16))
                ),
                RaisedButton(
                  color: LocaleSettings.currentLocale == 'en' ? OvguColor.primary : OvguColor.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(15))
                  ),
                  onPressed: () {
                    setState(() {
                      Globals.ikusAppState.setLocale('en');
                    });
                  },
                  child: Text('EN', style: TextStyle(color: LocaleSettings.currentLocale == 'en' ? Colors.white : Colors.black)),
                ),
                RaisedButton(
                  color: LocaleSettings.currentLocale == 'de' ? OvguColor.primary : OvguColor.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(15))
                  ),
                  onPressed: () {
                    setState(() {
                      Globals.ikusAppState.setLocale('de');
                    });
                  },
                  child: Text('DE', style: TextStyle(color: LocaleSettings.currentLocale == 'de' ? Colors.white : Colors.black)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
