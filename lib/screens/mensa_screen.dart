import 'package:flutter/material.dart';
import 'package:ikus_app/animations/smart_animation.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/food_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/mensa_info.dart';
import 'package:ikus_app/service/mensa_service.dart';
import 'package:ikus_app/utility/globals.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:intl/intl.dart';

class MensaScreen extends StatefulWidget {

  @override
  _MensaScreenState createState() => _MensaScreenState();
}

class _MensaScreenState extends State<MensaScreen> {

  static DateFormat _lastUpdateFormatter = DateFormat("dd.MM.yyyy, HH:mm");
  static DateFormat _lastUpdateFormatterTimeOnly = DateFormat("HH:mm");
  static DateFormat _dateFormatter = DateFormat("dd.MM.yyyy");
  DateFormat _dateWithWeekdayFormatter = DateFormat("EEEE, dd.MM.yyyy", LocaleSettings.currentLocale);

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<SmartAnimationState> _headerAnimationKey = new GlobalKey<SmartAnimationState>();
  final GlobalKey<SmartAnimationState> _bodyAnimationKey = new GlobalKey<SmartAnimationState>();
  List<MensaInfo> menu;
  int index = 0;

  @override
  void initState() {
    super.initState();
    menu = MensaService.instance.getMenu();
    index = 0;

    Duration durationNotUpdated = DateTime.now().difference(MensaService.instance.getLastUpdate());
    if (durationNotUpdated > Duration(minutes: 15)) {
      // update
      nextFrame(() {
        _refreshIndicatorKey.currentState.show();
      });
    }
  }

  void prevLocation() {

    if (menu.isEmpty)
      return;

    setState(() {
      index--;
      if (index == -1)
        index = menu.length - 1;
      _headerAnimationKey.currentState.startAnimation();
      _bodyAnimationKey.currentState.startAnimation();
    });
  }

  void nextLocation() {

    if (menu.isEmpty)
      return;

    setState(() {
      index = (index + 1) % menu.length;
      _headerAnimationKey.currentState.startAnimation();
      _bodyAnimationKey.currentState.startAnimation();
    });
  }

  String formatDate(DateTime timestamp) {
    DateTime today = DateTime.now();
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    if (today.day == timestamp.day && today.month == timestamp.month && today.year == timestamp.year) {
      return t.mensa.today(date: _dateFormatter.format(timestamp));
    } else if (tomorrow.day == timestamp.day && tomorrow.month == timestamp.month && tomorrow.year == timestamp.year) {
      return t.mensa.tomorrow(date: _dateFormatter.format(timestamp));
    } else {
      return _dateWithWeekdayFormatter.format(timestamp);
    }
  }

  String formatLastUpdate(DateTime timestamp) {
    DateTime today = DateTime.now();
    if (today.day == timestamp.day && today.month == timestamp.month && today.year == timestamp.year) {
      return t.mensa.today(date: _lastUpdateFormatterTimeOnly.format(timestamp));
    } else {
      return _lastUpdateFormatter.format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {

    MensaInfo curr = menu.isNotEmpty ? menu[index] : MensaInfo(name: Mensa.UNI_CAMPUS_DOWN, menus: []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.mensa.title),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: OvguColor.primary,
        onRefresh: () async {
          await MensaService.instance.sync(useCache: false);
          setState(() {
            menu = MensaService.instance.getMenu();
            if (menu.isNotEmpty)
              index = index % menu.length;
          });
        },
        child: MainListView(
          children: [
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: OvguPixels.mainScreenPadding,
                child: IconText(
                  icon: Icons.access_time,
                  text: t.mensa.lastUpdate(timestamp: formatLastUpdate(MensaService.instance.getLastUpdate())),
                  color: OvguColor.secondaryDarken2,
                  size: 14,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                height: 80,
                child: Row(
                  children: [
                    OvguButton(
                      type: OvguButtonType.ICON,
                      flat: true,
                      padding: EdgeInsets.zero,
                      callback: prevLocation,
                      child: Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SmartAnimation(
                          key: _headerAnimationKey,
                          duration: Duration(milliseconds: 500),
                          startPosition: Offset(30,0),
                          endPosition: Offset(0,0),
                          startOpacity: 0,
                          endOpacity: 1,
                          curve: Curves.easeOutCubic,
                          child: Text(curr.name.name, style: TextStyle(color: OvguColor.primary, fontSize: 30))
                        ),
                      ),
                    ),
                    OvguButton(
                      type: OvguButtonType.ICON,
                      flat: true,
                      callback: nextLocation,
                      child: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            SmartAnimation(
              key: _bodyAnimationKey,
              startImmediately: false,
              duration: Duration(milliseconds: 500),
              startPosition: Offset(0,10),
              endPosition: Offset(0,0),
              curve: Curves.easeOut,
              child: Column(
                children: [
                  ...curr.menus.map((menu) => Padding(
                    padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Text(formatDate(menu.date), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ...menu.food.map((food) => FoodCard(food: food))
                      ],
                    ),
                  )),
                  if (curr.menus.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(t.mensa.noData, style: TextStyle(fontSize: 20)),
                    ),
                ],
              ),
            ),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
