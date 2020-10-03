import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ikus_app/components/bottom_navigator.dart';
import 'package:ikus_app/components/tutorial_background.dart';
import 'package:ikus_app/components/status_bar_color.dart';
import 'package:ikus_app/components/tutorial_overlay.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/pages/calendar_page.dart';
import 'package:ikus_app/pages/features_page.dart';
import 'package:ikus_app/pages/home_page.dart';
import 'package:ikus_app/pages/settings_page.dart';

class MainScreen extends StatefulWidget {

  final bool tutorial;

  const MainScreen({this.tutorial = false});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget> pages;
  PageController _pageController;
  int _page;

  bool tutorialMode;
  int currTutorialStep;
  final int tutorialStepCount = 5;
  Offset tutorialPosition; // will be set on first build
  String tutorialText; // will be set on first build
  String tutorialProgress; // will be set on first build

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
  }

  void animateToPage(int index) {
    _pageController.animateToPage(
        index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void nextTutorial() {
    setState(() {
      currTutorialStep++;
      applyTutorialStep(context, currTutorialStep);
    });
  }

  Future<void> applyTutorialStep(BuildContext context, int step) async {
    Size size = MediaQuery.of(context).size;
    tutorialProgress = '${step + 1} / $tutorialStepCount';
    if (step < t.tutorial.steps.length)
      tutorialText = t.tutorial.steps[step];
    switch (step) {
      case 0:
        tutorialPosition = Offset((size.width - TutorialOverlay.TOTAL_WIDTH) / 2 - 30, 200);
        break;
      case 1:
        animateToPage(1);
        tutorialPosition = Offset((size.width - TutorialOverlay.TOTAL_WIDTH) / 2, 300);
        break;
      case 2:
        animateToPage(2);
        tutorialPosition = Offset((size.width - TutorialOverlay.TOTAL_WIDTH) / 2 - 30, 270);
        break;
      case 3:
        animateToPage(0);
        tutorialPosition = Offset((size.width - TutorialOverlay.TOTAL_WIDTH) / 2 - 30, 110);
        break;
      case 4:
        tutorialPosition = Offset((size.width - TutorialOverlay.TOTAL_WIDTH) / 2 - 30, 300);
        break;
      default:
        tutorialPosition = Offset((size.width - TutorialOverlay.TOTAL_WIDTH) / 2 - 30, -300);
        Future.delayed(Duration(milliseconds: 1000))
          .whenComplete(() {
            setState(() {
              tutorialMode = false;
            });
          });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    if (tutorialMode && tutorialPosition == null)
      applyTutorialStep(context, currTutorialStep);

    return StatusBarColor(
      brightness: Brightness.light,
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return Stack(
            children: [
              PageView(
                controller: _pageController,
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
                AnimatedPositioned(
                  top: tutorialPosition.dy,
                  left: tutorialPosition.dx,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOutCubic,
                  child: TutorialOverlay(
                    text: tutorialText,
                    progress: tutorialProgress,
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
              animateToPage(index);
            });
          },
          disabled: tutorialMode,
        ),
      ),
    );
  }
}
