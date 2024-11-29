import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ikus_app/components/bottom_navigator.dart';
import 'package:ikus_app/components/popups/need_update_popup.dart';
import 'package:ikus_app/components/status_bar_color.dart';
import 'package:ikus_app/components/tutorial/tutorial_background.dart';
import 'package:ikus_app/components/tutorial/tutorial_feature_highlight.dart';
import 'package:ikus_app/components/tutorial/tutorial_overlay.dart';
import 'package:ikus_app/gen/strings.g.dart';
import 'package:ikus_app/init.dart';
import 'package:ikus_app/pages/calendar_page.dart';
import 'package:ikus_app/pages/features_page.dart';
import 'package:ikus_app/pages/home_page.dart';
import 'package:ikus_app/pages/settings_page.dart';
import 'package:ikus_app/service/app_config_service.dart';
import 'package:ikus_app/service/notification_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';

class MainScreen extends StatefulWidget {

  static GlobalKey<_MainScreenState> mainScreenKey = GlobalKey();
  final bool tutorial;
  final SimpleWidgetBuilder? screen;

  const MainScreen({Key? key, this.tutorial = false, this.screen}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late List<Widget> pages;
  late PageController _pageController;
  int _page = 0;

  late bool tutorialMode;
  int currTutorialStep = 0;
  final int tutorialStepCount = 6;
  Offset? tutorialPosition; // will be set on first build
  String? tutorialText; // will be set on first build
  String? tutorialProgress; // will be set on first build
  bool? tutorialFavoritesHighlight; // will be set on first build
  bool? tutorialFeatureHeartHighlight; // will be set on first build

  @override
  void initState() {
    super.initState();

    pages = [
      HomePage(),
      CalendarPage(),
      FeaturesPage(),
      SettingsPage()
    ];
    _pageController = PageController();
    _page = 0;
    tutorialMode = widget.tutorial;
    currTutorialStep = 0;
    if (widget.screen != null) {
      nextFrame(() {
        pushScreen(context, widget.screen!);
      });
    }
    showNeedUpdateIfNeeded();
  }

  Future<void> showNeedUpdateIfNeeded() async {
    await Init.awaitPostInit();
    if (!AppConfigService.instance.isCompatibleWithApi()) {
      await NeedUpdatePopup.open(context);
    }
  }

  void animateToPage(int index) {
    _pageController.animateToPage(
        index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void jumpToPage(int index) {
    _pageController.jumpToPage(index);
  }

  void nextTutorial() {
    setState(() {
      currTutorialStep++;
      applyTutorialStep(context, currTutorialStep);
    });
  }

  void skipTutorial() {
    setState(() {
      currTutorialStep = tutorialStepCount;
      applyTutorialStep(context, currTutorialStep);
    });
  }

  Future<void> applyTutorialStep(BuildContext context, int step) async {
    Size size = MediaQuery.of(context).size;
    double actualWidth = min(size.width, OvguPixels.maxWidth);
    double actualStart = (size.width - actualWidth) / 2;
    if (step < t.tutorial.steps.length) {
      tutorialText = t.tutorial.steps[step];
      tutorialProgress = '${step + 1} / $tutorialStepCount';
    }
    switch (step) {
      case 0:
        // home page
        tutorialPosition = Offset(actualStart + (actualWidth - TutorialOverlay.TOTAL_WIDTH) / 2 - 30, 200);
        tutorialFavoritesHighlight = false;
        tutorialFeatureHeartHighlight = false;
        break;
      case 1:
        // calendar page
        animateToPage(1);
        tutorialPosition = Offset(actualStart + (actualWidth - TutorialOverlay.TOTAL_WIDTH) / 2, size.height - TutorialOverlay.APPROX_HEIGHT - 150);
        break;
      case 2:
        // feature page
        animateToPage(2);
        tutorialPosition = Offset(actualStart, min(size.height - TutorialOverlay.APPROX_HEIGHT - 50, 390));
        break;
      case 3:
        // feature page (highlight hearts)
        tutorialPosition = Offset(actualStart, min(size.height - TutorialOverlay.APPROX_HEIGHT - 50, 390));
        tutorialFeatureHeartHighlight = true;
        break;
      case 4:
        // home page
        animateToPage(0);
        tutorialPosition = Offset(actualStart, 110);
        tutorialFeatureHeartHighlight = false;
        await sleep(1000);
        setState(() {
          tutorialFavoritesHighlight = true;
        });
        break;
      case 5:
        // last
        tutorialPosition = Offset((size.width - TutorialOverlay.TOTAL_WIDTH) / 2 - 30, (size.height - TutorialOverlay.APPROX_HEIGHT) / 2);
        tutorialFavoritesHighlight = false;
        break;
      default:
        // end
        tutorialPosition = Offset((size.width - TutorialOverlay.TOTAL_WIDTH) / 2 - 30, -300);
        await sleep(1000);
        setState(() {
          tutorialMode = false;
        });
        if (Platform.isIOS) {
          // request notification permission on iOS
          await NotificationService.requestIOSPermissions();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (tutorialMode && tutorialPosition == null)
      applyTutorialStep(context, currTutorialStep);

    Size size = MediaQuery.of(context).size;

    return StatusBarColor(
      brightness: Brightness.light,
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return Stack(
            children: [
              PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _page = index;
                  });
                },
                children: pages,
              ),
              if (tutorialMode)
                TutorialBackground(),
              if (tutorialMode)
                SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 0, maxWidth: OvguPixels.maxWidth),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 67, right: 3),
                          child: TutorialFeatureHighlight(
                            visible: tutorialFeatureHeartHighlight!,
                            width: 60,
                            height: AppConfigService.instance.getFeatures().length * 54.0
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (tutorialMode)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TutorialFeatureHighlight(
                        visible: tutorialFavoritesHighlight!,
                        width: min(size.width, OvguPixels.maxWidth) - 15,
                        height: 90
                      ),
                    ),
                  ),
                ),
              if (tutorialMode)
                AnimatedPositioned(
                  top: tutorialPosition!.dy,
                  left: tutorialPosition!.dx,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOutCubic,
                  child: TutorialOverlay(
                    text: tutorialText!,
                    progress: tutorialProgress!,
                    isLast: currTutorialStep >= tutorialStepCount - 1,
                    onSkip: skipTutorial,
                    onNext: nextTutorial,
                  )
                )
            ],
          );
        }),
        bottomNavigationBar: BottomNavigator(
          selectedIndex: _page,
          callback: (index) {
            setState(() {
              jumpToPage(index);
            });
          },
          disabled: tutorialMode,
        ),
      ),
    );
  }
}
