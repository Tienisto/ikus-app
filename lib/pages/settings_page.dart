import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/ovgu_switch.dart';
import 'package:ikus_app/components/popups/reset_popup.dart';
import 'package:ikus_app/components/settings_item.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/about_screen.dart';
import 'package:ikus_app/screens/change_language_screen.dart';
import 'package:ikus_app/screens/dev_screen.dart';
import 'package:ikus_app/screens/ovgu_account_screen.dart';
import 'package:ikus_app/screens/sync_screen.dart';
import 'package:ikus_app/screens/welcome_screen.dart';
import 'package:ikus_app/service/persistent_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:package_info/package_info.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  static const Color LOGO_COLOR = Color(0xFFAFAFAF);
  String _version = '';
  int devCounter = 0;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _version = info.version+' ('+info.buildNumber+')';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return SafeArea(
      child: MainListView(
        padding: OvguPixels.mainScreenPadding,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          IconText(
            size: OvguPixels.headerSize,
            distance: OvguPixels.headerDistance,
            icon: Icons.settings,
            text: t.main.settings.title,
          ),
          SizedBox(height: 20),
          SettingsItem(
              left: t.main.settings.language,
              right: OvguSwitch(
                state: LocaleSettings.currentLocale == 'en' ? SwitchState.LEFT : SwitchState.RIGHT,
                left: 'EN',
                right: 'DE',
                callback: (state) {
                  String locale = state == SwitchState.LEFT ? 'en' : 'de';
                  if (locale == LocaleSettings.currentLocale)
                    return;
                  LocaleSettings.setLocale(locale);
                  SettingsService.instance.setLocale(locale);
                  setScreen(context, () => ChangeLanguageScreen());
                },
              )
          ),
          SizedBox(height: 20),
          SettingsItem(
              left: t.main.settings.account,
              right: OvguButton(
                callback: () {
                  pushScreen(context, () => OvguAccountScreen());
                },
                child: Icon(Icons.person, color: Colors.white),
              )
          ),
          SizedBox(height: 20),
          SettingsItem(
              left: t.main.settings.sync,
              right: OvguButton(
                callback: () {
                  pushScreen(context, () => SyncScreen());
                },
                child: Icon(Icons.sync, color: Colors.white),
              )
          ),
          SizedBox(height: 20),
          SettingsItem(
              left: t.main.settings.reset,
              right: OvguButton(
                callback: () {
                  ResetPopup.open(
                    context: context,
                    callback: () async {
                      bool devServer = SettingsService.instance.getDevServer();
                      await PersistentService.instance.clearData();
                      await SettingsService.instance.loadFromStorage();
                      SettingsService.instance.setDevServer(devServer); // set value before the deletion
                      for (SyncableService service in SyncableService.services) {
                        await service.sync(useNetwork: false);
                      }
                      nextFrame(() {
                        setScreen(context, () => WelcomeScreen());
                      });
                    }
                  );
                },
                child: Icon(Icons.restore, color: Colors.white),
              )
          ),
          SizedBox(height: 20),
          SettingsItem(
              left: t.main.settings.licenses,
              right: OvguButton(
                callback: () {
                  pushScreen(context, () => LicensePage(applicationName: t.main.settings.appName, applicationVersion: _version));
                },
                child: Icon(Icons.description, color: Colors.white),
              )
          ),
          SizedBox(height: 20),
          SettingsItem(
              left: t.main.settings.about,
              right: OvguButton(
                callback: () {
                  pushScreen(context, () => AboutScreen());
                },
                child: Icon(Icons.info, color: Colors.white),
              )
          ),
          if (SettingsService.instance.getDevSettings())
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SettingsItem(
                  left: t.main.settings.dev,
                  right: OvguButton(
                    callback: () async {
                      await pushScreen(context, () => DevScreen());
                      setState(() {}); // in case user disables dev settings
                    },
                    child: Icon(Icons.developer_mode, color: Colors.white),
                  )
              ),
            ),
          SizedBox(height: 50),
          Opacity(
            opacity: 0.3,
            child: Image.asset('assets/img/logo-512-alpha.png', width: 200)
          ),
          SizedBox(height: 10),
          Text(t.main.settings.appName, style: TextStyle(color: LOGO_COLOR, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              setState(() {
                devCounter++;
                if (devCounter >= 7) {
                  SettingsService.instance.setDevSettings(true);
                }
              });
            },
            child: Text('Version $_version', style: TextStyle(color: LOGO_COLOR, fontSize: 14)),
          ),
          SizedBox(height: 5),
          Text('© 2020 OVGU', style: TextStyle(color: LOGO_COLOR, fontSize: 14)),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
