import 'package:flutter/material.dart';
import 'package:ikus_app/i18n/strings.g.dart';
import 'package:ikus_app/model/food.dart';
import 'package:ikus_app/utility/ui.dart';
import 'package:intl/intl.dart';

class CardFood extends StatelessWidget {
  static NumberFormat currencyFormat =
      NumberFormat("#.00", LocaleSettings.currentLocale);
  final Food food;

  const CardFood({@required this.food});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        color: OvguColor.secondary,
        shape: OvguPixels.shape,
        elevation: OvguPixels.elevation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Row(
                      children: food.tags.map((tag) => Card(
                        color: tag.color,
                        shape: OvguPixels.shape,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text(tag.name, style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: OvguColor.primary,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(OvguPixels.borderRadiusPlain), bottomLeft: Radius.circular(OvguPixels.borderRadiusPlain))
                    ),
                    child: Text(currencyFormat.format(food.price) + ' €', style: TextStyle(color: Colors.white))
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5, right: 10, bottom: 10),
              child: Text(food.name),
            )
          ],
        ),
      ),
    );
  }
}
