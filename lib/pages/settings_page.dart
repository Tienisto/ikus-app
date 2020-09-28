import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/components/ovgu_switch.dart';
import 'package:ikus_app/components/popups/reset_popup.dart';
import 'package:ikus_app/components/rotating.dart';
import 'package:ikus_app/components/settings_item.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/about_screen.dart';
import 'package:ikus_app/screens/dev_screen.dart';
import 'package:ikus_app/service/api_service.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/callbacks.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/popups.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  static DateFormat _dateFormatter = DateFormat("dd.MM.yyyy, HH:mm");
  static const Color LOGO_COLOR = Color(0xFFAFAFAF);
  String _version = '';

  Map<String, bool> syncing = Map();

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

  Widget getSyncItem(String name, DateTime lastUpdate, FutureCallback callback) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(_dateFormatter.format(lastUpdate))
                ],
              )
          ),
          OvguButton(
            type: OvguButtonType.ICON_WIDE,
            flat: true,
            callback: () async {
              setState(() {
                syncing[name] = true;
              });
              await callback();
              setState(() {
                syncing[name] = false;
              });
            },
            child: syncing[name] == true ? Rotating(child: Icon(Icons.sync)) : Icon(Icons.sync),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    String locale = state == SwitchState.LEFT ? 'en' : 'de';
                    Globals.ikusAppState.setLocale(locale);
                    SettingsService.instance.setLocale(locale);
                  });
                },
              )
          ),
          SizedBox(height: 20),
          OvguCard(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.main.settings.sync, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(t.main.settings.syncInfo),
                  SizedBox(height: 5),
                  ...SyncableService.services.map((service) {
                    return getSyncItem(service.getName(), service.getLastUpdate(), () async {
                      await service.sync(useCacheOnly: false);
                    });
                  })
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          SettingsItem(
              left: t.main.settings.reset,
              right: OvguButton(
                type: OvguButtonType.ICON_WIDE,
                callback: () async {
                  Popups.generic(
                      context: context,
                      height: 240,
                      body: ResetPopup(
                        callback: () async {
                          await SettingsService.instance.clear();
                          await ApiService.clearCache();
                          for (SyncableService service in SyncableService.services) {
                            await service.sync(useCacheOnly: true);
                          }
                          setState(() {});
                        },
                      )
                  );
                },
                child: Icon(Icons.restore, color: Colors.white),
              )
          ),
          SizedBox(height: 20),
          SettingsItem(
              left: t.main.settings.licenses,
              right: OvguButton(
                type: OvguButtonType.ICON_WIDE,
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
                type: OvguButtonType.ICON_WIDE,
                callback: () {
                  pushScreen(context, () => AboutScreen());
                },
                child: Icon(Icons.info, color: Colors.white),
              )
          ),
          if (devCounter >= 7 || SettingsService.instance.getDevServer())
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SettingsItem(
                  left: t.main.settings.dev,
                  right: OvguButton(
                    type: OvguButtonType.ICON_WIDE,
                    callback: () {
                      pushScreen(context, () => DevScreen());
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
