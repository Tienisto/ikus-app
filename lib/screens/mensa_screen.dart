import 'package:flutter/material.dart';
import 'package:ikus_app/components/buttons/ovgu_button.dart';
import 'package:ikus_app/components/cards/food_card.dart';
import 'package:ikus_app/components/icon_text.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/menu.dart';
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

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  List<MapEntry<MensaLocation, List<Menu>>> menu;
  int index = 0;

  @override
  void initState() {
    super.initState();
    menu = MensaService.instance.getMenu().entries.toList();
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
    setState(() {
      index--;
      if (index == -1)
        index = menu.length - 1;
    });
  }

  void nextLocation() {
    setState(() {
      index = (index + 1) % menu.length;
    });
  }

  String formatDate(DateTime timestamp) {
    DateTime today = DateTime.now();
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    String dateString = _dateFormatter.format(timestamp);
    if (today.day == timestamp.day && today.month == timestamp.month && today.year == timestamp.year) {
      return t.mensa.today(date: dateString);
    } else if (tomorrow.day == timestamp.day && tomorrow.month == timestamp.month && tomorrow.year == timestamp.year) {
      return t.mensa.tomorrow(date: dateString);
    } else {
      return dateString;
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

    MapEntry<MensaLocation, List<Menu>> curr = menu[index];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.mensa.title),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: OvguColor.primary,
        onRefresh: () async {
          await MensaService.instance.sync();
          setState(() {
            menu = MensaService.instance.getMenu().entries.toList();
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
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(curr.key.name, style: TextStyle(color: OvguColor.primary, fontSize: 30)),
                        ],
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
            SizedBox(height: 50),
            ...curr.value.map((menu) => Padding(
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
            if (curr.value.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Text(t.mensa.noData, style: TextStyle(fontSize: 20)),
              ),
            SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
