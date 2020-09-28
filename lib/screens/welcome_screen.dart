import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/status_bar_color.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return StatusBarColor(
      brightness: Brightness.dark,
      child: Scaffold(
        body: SizedBox.expand(
          child: Container(
            color: OvguColor.primary,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/img/logo-512-alpha.png', width: 200),
                        SizedBox(height: 20),
                        Text(t.welcome.title, style: TextStyle(color: Colors.white, fontSize: 30), textAlign: TextAlign.center),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(child: Text(t.welcome.intro, style: TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center)),
                        ),
                      ],
                    ),
                  ),
                  OvguCard(
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 25, bottom: 25, right: 25),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(t.welcome.selectLanguage, style: TextStyle(fontSize: 20)),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OvguButton(
                              color: LocaleSettings.currentLocale == 'en' ? OvguColor.primary : Colors.grey[300],
                              callback: () {
                                setState(() {
                                  LocaleSettings.setLocale('en');
                                  SettingsService.instance.setLocale('en');
                                });
                              },
                              child: Text(t.welcome.english, style: TextStyle(color: LocaleSettings.currentLocale == 'en' ? Colors.white : Colors.black)),
                            ),
                            OvguButton(
                              color: LocaleSettings.currentLocale == 'de' ? OvguColor.primary : Colors.grey[300],
                              callback: () {
                                setState(() {
                                  LocaleSettings.setLocale('de');
                                  SettingsService.instance.setLocale('de');
                                });
                              },
                              child: Text(t.welcome.german, style: TextStyle(color: LocaleSettings.currentLocale == 'de' ? Colors.white : Colors.black)),
                            )
                          ],
                        ),
                        SizedBox(height: 50),
                        OvguButton(
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          callback: () {
                            SettingsService.instance.setWelcome(false);
                            setScreen(context, () => MainScreen());
                          },
                          child: Text(t.welcome.start, style: TextStyle(fontSize: 30, color: Colors.white)),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
