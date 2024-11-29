import 'package:flutter/material.dart';
import 'package:ikus_app/animations/fade_page_route.dart';
import 'package:ikus_app/animations/smart_animation.dart';
import 'package:ikus_app/components/animated_progress_bar.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/ovgu_card.dart';
import 'package:ikus_app/components/status_bar_color.dart';
import 'package:ikus_app/components/tutorial/tutorial_overlay.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/screens/main_screen.dart';
import 'package:ikus_app/service/settings_service.dart';
import 'package:ikus_app/service/syncable_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final GlobalKey<SmartAnimationState> _titleKey = new GlobalKey<SmartAnimationState>();
  final GlobalKey<SmartAnimationState> _introKey = new GlobalKey<SmartAnimationState>();
  final GlobalKey<SmartAnimationState> _cardKey = new GlobalKey<SmartAnimationState>();
  final GlobalKey<SmartAnimationState> _progressBarKey = new GlobalKey<SmartAnimationState>();
  bool _starting = false;
  double _progress = 0;

  Future<void> startApp() async {
    setState(() {
      _starting = true;
    });
    await sleep(500);
    _progressBarKey.currentState?.startAnimation();
    await sleep(500);
    List<SyncableService> services = SyncableService.services;
    for (int i = 0; i < services.length; i++) {
      await services[i].sync(useNetwork: true);
      await sleep(100);
      setState(() {
        _progress = (i+1) / services.length;
      });
    }
    await sleep(500);
    _titleKey.currentState?.startReverseAnimation();
    _introKey.currentState?.startReverseAnimation();
    _cardKey.currentState?.startReverseAnimation();
    await sleep(1000);
    SettingsService.instance.setWelcome(false);
    await Navigator.pushAndRemoveUntil(context,
        FadePageRoute(
            duration: Duration(milliseconds: 1500),
            builder: (_) => MainScreen(tutorial: true, key: MainScreen.mainScreenKey)
        ), (_) => false);
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
                          duration: Duration(milliseconds: 1000),
                          delay: Duration(milliseconds: 500),
                          startPosition: Offset(0, -500),
                          startOpacity: 0,
                          curve: Curves.easeOutCubic,
                          child: Hero(
                            tag: TutorialOverlay.HERO_TAG,
                            child: Image.asset('assets/img/logo-512-alpha.png', width: 150)
                          )
                        ),
                        SizedBox(height: 10),
                        SmartAnimation(
                          key: _titleKey,
                          duration: Duration(milliseconds: 500),
                          delay: Duration(milliseconds: 2000),
                          startOpacity: 0,
                          child: Text(t.welcome.title, style: TextStyle(color: Colors.white, fontSize: 30), textAlign: TextAlign.center)
                        ),
                        SizedBox(height: 20),
                        SmartAnimation(
                          key: _introKey,
                          duration: Duration(milliseconds: 500),
                          delay: Duration(milliseconds: 3000),
                          startOpacity: 0,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Center(child: Text(t.welcome.intro, style: TextStyle(color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic), textAlign: TextAlign.center)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SmartAnimation(
                    key: _cardKey,
                    duration: Duration(milliseconds: 500),
                    delay: Duration(milliseconds: 4000),
                    startPosition: Offset(0, 500),
                    startOpacity: 0,
                    curve: Curves.easeOutCubic,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
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
                                    color: LocaleSettings.currentLocale == AppLocale.en ? OvguColor.primary : Colors.grey.shade300,
                                    callback: () {
                                      setState(() {
                                        LocaleSettings.setLocale(AppLocale.en);
                                        SettingsService.instance.setLocale('en');
                                      });
                                    },
                                    child: Text(t.welcome.english, style: TextStyle(color: LocaleSettings.currentLocale == AppLocale.en ? Colors.white : Colors.black)),
                                  ),
                                  OvguButton(
                                    color: LocaleSettings.currentLocale == AppLocale.de ? OvguColor.primary : Colors.grey.shade300,
                                    callback: () {
                                      setState(() {
                                        LocaleSettings.setLocale(AppLocale.de);
                                        SettingsService.instance.setLocale('de');
                                      });
                                    },
                                    child: Text(t.welcome.german, style: TextStyle(color: LocaleSettings.currentLocale == AppLocale.de ? Colors.white : Colors.black)),
                                  )
                                ],
                              ),
                              SizedBox(height: 50),
                              OvguButton(
                                color: Colors.green,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                callback: () {
                                  startApp();
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: SmartAnimation(
                                  key: _progressBarKey,
                                  startImmediately: false,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                  startOpacity: 0,
                                  child: AnimatedProgressBar(
                                    progress: _progress,
                                    reactDuration: Duration(milliseconds: 100),
                                    backgroundColor: OvguColor.secondary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
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
