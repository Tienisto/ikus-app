import 'package:flutter/material.dart';
import 'package:ikus_app/animations/smart_animation.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/status_bar_color.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation<double> _animationProgress;

  bool _starting = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 180),
    )..addListener(() {
      setState(() {
        _progress = _animationProgress.value;
      });
    });
  }

  Future<void> startApp() async {
    await sleep(1500);
    List<SyncableService> services = SyncableService.services;
    for (int i = 0; i < services.length; i++) {
      await services[i].sync(useCacheOnly: false);
      await sleep(200);
      setState(() {
        _animationProgress = Tween<double>(
            begin: i / services.length,
            end: (i+1) / services.length
        ).animate(_animationController);

        _animationController.forward(from: 0);
        _progress = (i+1) / services.length;
      });
    }
    await sleep(2000);
    SettingsService.instance.setWelcome(false);
    setScreen(context, () => MainScreen());
  }

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
                        SmartAnimation(
                          duration: Duration(milliseconds: 3000),
                          delay: Duration(milliseconds: 500),
                          startPosition: Offset(0, -300),
                          curve: Curves.elasticOut,
                          child: Image.asset('assets/img/logo-512-alpha.png', width: 200)
                        ),
                        SizedBox(height: 20),
                        SmartAnimation(
                          duration: Duration(milliseconds: 500),
                          delay: Duration(milliseconds: 2000),
                          startOpacity: 0,
                          child: Text(t.welcome.title, style: TextStyle(color: Colors.white, fontSize: 30), textAlign: TextAlign.center)
                        ),
                        SizedBox(height: 20),
                        SmartAnimation(
                          duration: Duration(milliseconds: 500),
                          delay: Duration(milliseconds: 3000),
                          startOpacity: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(child: Text(t.welcome.intro, style: TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SmartAnimation(
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 6000),
                    startPosition: Offset(0, 500),
                    startOpacity: 0,
                    curve: Curves.easeOutCubic,
                    child: OvguCard(
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 25, bottom: 25, right: 25),
                      child: AnimatedCrossFade(
                        crossFadeState: _starting ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 500),
                        sizeCurve: Curves.easeOutCubic,
                        firstChild: Column(
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
                                setState(() {
                                  _starting = true;
                                  startApp();
                                });
                              },
                              child: Text(t.welcome.start, style: TextStyle(fontSize: 30, color: Colors.white)),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        secondChild: Column(
                          children: [
                            SizedBox(height: 20),
                            Text(t.welcome.loading, style: TextStyle(fontSize: 20)),
                            SizedBox(height: 20),
                            LinearProgressIndicator(
                              minHeight: 10,
                              value: _progress,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
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
