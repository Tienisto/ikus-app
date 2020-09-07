import 'package:flutter/material.dart';
import 'package:ikus_app/components/cards/food_card.dart';
import 'package:ikus_app/components/main_list_view.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/menu.dart';
import 'package:ikus_app/service/mensa_service.dart';
import 'package:ikus_app/utility/adaptive.dart';
import 'package:ikus_app/utility/ui.dart';

class MensaScreen extends StatelessWidget {

  Widget getMenu(Menu menu) {
    return MainListView(
      children: [
        Center(child: Text(menu.location.name, style: TextStyle(fontSize: OvguPixels.headerSize))),
        SizedBox(height: 10),
        Padding(
          padding: OvguPixels.mainScreenPadding,
          child: Column (
            children: menu.food.map((food) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: FoodCard(food: food),
            )).toList(),
          ),
        ),
        SizedBox(height: 20)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Menu> menu = MensaService.instance.getMenu();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: OvguColor.primary,
        title: Text(t.mensa.title),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Text('Donnerstag, 11.08.2020', textAlign: TextAlign.center, style: TextStyle(color: OvguColor.primary, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 40),
          Expanded(
            child: PageView(
              physics: Adaptive.getScrollPhysics(),
              children: menu.map((m) => getMenu(m)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
