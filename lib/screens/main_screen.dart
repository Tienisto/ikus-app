import 'package:flutter/material.dart';
import 'package:ikus_app/components/bottom_navigator.dart';
import 'package:ikus_app/pages/calendar_page.dart';
import 'package:ikus_app/pages/features_page.dart';
import 'package:ikus_app/pages/home_page.dart';
import 'package:ikus_app/pages/settings_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget> pages;
  PageController _pageController;
  int _page;

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
  }

  void animateToPage(int index) {
    print('[main screen] animate to page $index');
    setState(() {
      _pageController.animateToPage(
        index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _page = index;
            });
          },
          children: pages,
        );
      }),
      bottomNavigationBar: BottomNavigator(_page, animateToPage),
    );
  }
}
